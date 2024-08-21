//
//  PhotoManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-20.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

protocol OperationCallback {
    func onSuccess()
    func onFailure(_ error: String)
}

protocol ListOperationCallback {
    func onSuccess(_ imageUrls: [URL])
    func onFailure(_ error: String)
}

class PhotoService {
    private var reference: DatabaseReference
    private let collectionName = "photos"
    private var storageReference: StorageReference
    
    init() {
        self.reference = Database.database().reference()
        self.storageReference = Storage.storage().reference()
    }

    func addFoodPhotos(_ model: Photos, completion: @escaping (Result<Void, Error>) -> Void) {
        // Generate a new item key
        guard let newItemKey = reference.child(collectionName).childByAutoId().key else {
            // If key generation fails, return an error
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate a unique key."])))
            return
        }
        
        // Safely unwrap the key and assign it to model.photoId
        model.photoId = newItemKey
        
        // Save the model to Firebase using the new key
        reference.child(collectionName).child(newItemKey).setValue(model.toDictionary()) { error, _ in
            if let error = error {
                // Call the completion handler with failure if there's an error
                completion(.failure(error))
            } else {
                // Call the completion handler with success if the operation is successful
                completion(.success(()))
            }
        }
    }



//    func getAllPhotosByDonationId(_ uid: String, callback: ListOperationCallback?) {
//        reference.child(collectionName)
//            .queryOrdered(byChild: "donationId")
//            .queryEqual(toValue: uid)
//            .observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
//                
//                // Check if the snapshot contains any data
//                guard snapshot.exists() else {
//                    callback?.onFailure("Photos not found")
//                    return
//                }
//                
//                var photosList: [Photos] = []
//                
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot,
//                       let photo = Photos(snapshot: childSnapshot) {
//                        photosList.append(photo)
//                    }
//                }
//                
//                // Sort photos by order
//                photosList.sort { $0.order < $1.order }
//                
//                // Map photos to URLs
//                let imageUrls = photosList.compactMap { URL(string: $0.imagePath ?? "") }
//                
//                // Call the success callback with the URLs
//                callback?.onSuccess(imageUrls)
//                
//            } withCancel: { error in
//                // Handle cancellation errors
//                callback?.onFailure(error.localizedDescription)
//            }
//    }

    func uploadImages(donationId: String, imageUris: [UIImage], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var uploadErrors: [Error] = []
        
        for (index, image) in imageUris.enumerated() {
            dispatchGroup.enter()
            
            let order = index + 1
            let fileReference = storageReference.child("foodimages/\(donationId)/\(UUID().uuidString).jpg")

            // Convert UIImage to Data
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                fileReference.putData(imageData, metadata: metadata) { _, error in
                    if let error = error {
                        uploadErrors.append(error)
                        dispatchGroup.leave()
                        return
                    }
                    
                    fileReference.downloadURL { url, error in
                        if let error = error {
                            uploadErrors.append(error)
                            dispatchGroup.leave()
                            return
                        }
                        
                        guard let downloadUrl = url else {
                            uploadErrors.append(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"]))
                            dispatchGroup.leave()
                            return
                        }
                        
                        let photo = Photos(donationId: donationId, imagePath: downloadUrl.absoluteString, order: order)
                        self.addFoodPhotos(photo) { result in
                            switch result {
                            case .success:
                                dispatchGroup.leave()
                            case .failure(let error):
                                uploadErrors.append(error)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
            } else {
                uploadErrors.append(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."]))
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if uploadErrors.isEmpty {
                completion(.success(()))
            } else {
                completion(.failure(uploadErrors.first!))
            }
        }
    }



    func deleteImage(donationId: String, photoPath: String) {
        let photoRef = reference.child(collectionName)
        let photoQuery = photoRef.queryOrdered(byChild: "donationId").queryEqual(toValue: donationId)

        photoQuery.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                var photoDeleted = false

                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if let storedPhotoPath = child.childSnapshot(forPath: "imagePath").value as? String, storedPhotoPath == photoPath {
                        self.deleteImageFromStorage(photoPath: storedPhotoPath)

                        child.ref.removeValue { error, _ in
                            if let error = error {
                                print("Failed to delete database entry. Error: \(error.localizedDescription)")
                            } else {
                                print("Image and database entry deleted successfully.")
                            }
                        }

                        photoDeleted = true
                        break
                    }
                }

                if !photoDeleted {
                    print("Photo path not found in the database.")
                }
            } else {
                print("No results found or results are empty.")
            }
        }
    }

    private func deleteImageFromStorage(photoPath: String) {
        let storageRef = Storage.storage().reference(forURL: photoPath)
        storageRef.delete { error in
            if let error = error {
                print("Failed to delete image from Firebase Storage. Error: \(error.localizedDescription)")
            } else {
                print("Image deleted from Firebase Storage.")
            }
        }
    }

    func updatePhotoOrder(donationId: String, callback: OperationCallback?) {
        let photosRef = Database.database().reference().child(collectionName)
        photosRef.queryOrdered(byChild: "donationId").queryEqual(toValue: donationId).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                callback?.onFailure("No photos found for this donationId.")
                return
            }

            var order = 1
            var failureOccurred = false

            for child in snapshot.children.allObjects as! [DataSnapshot] {
                child.ref.child("order").setValue(order) { error, _ in
                    if let error = error {
                        if !failureOccurred {
                            failureOccurred = true
                            callback?.onFailure("Error updating photo order: \(error.localizedDescription)")
                        }
                    }
                }
                order += 1
            }

            if !failureOccurred {
                callback?.onSuccess()
            }
        } withCancel: { error in
            callback?.onFailure("Database operation cancelled: \(error.localizedDescription)")
        }
    }
}

