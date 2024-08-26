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
    func getAllPhotosByDonationId(donationId: String, completion: @escaping (Result<[URL], Error>) -> Void) {
        let query = reference.child(collectionName).queryOrdered(byChild: "donationId").queryEqual(toValue: donationId)
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                print("PhotoService: snapshot does not exist")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Photos not found"])))
                return
            }
            
            var photosList: [Photos] = []
            
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let photoDict = childSnapshot.value as? [String: Any],
                   let donationId = photoDict["donationId"] as? String,
                   let order = photoDict["order"] as? Int {
                    
                    let imagePath = photoDict["imagePath"] as? String
                    let photo = Photos(donationId: donationId, imagePath: imagePath ?? "", order: order)
                    photosList.append(photo)
                } else {
                    print("PhotoService: photo is null")
                }
            }
            
            photosList.sort { $0.order < $1.order }
            
            let imageUrls: [URL] = photosList.compactMap {
                if let imagePath = $0.imagePath {
                    return URL(string: imagePath)
                }
                return nil
            }
            
            completion(.success(imageUrls))
        } withCancel: { error in
            print("PhotoService: Error - \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    func generateUniqueImageIdentifier() -> String {
        return UUID().uuidString
    }
        func updateImages(donationId: String, newImages: [UIImage], existingImageUrls: [String], imagesToRemove: [String], completion: @escaping (Result<Void, Error>) -> Void) {
            let dispatchGroup = DispatchGroup()
            var uploadErrors: [Error] = []
            var newImageUrls: [String] = []
            print("add new images cnt \(newImages.count)")
            print(" exiting images cnt \(existingImageUrls.count)")
            print(" remove images cnt \(imagesToRemove.count)")
            // 1. Upload new images
            for (index, image) in newImages.enumerated() {
                dispatchGroup.enter()
                print("inside to add new images\(image)")
              
                let imageId = generateUniqueImageIdentifier()
                let fileReference = storageReference.child("foodimages/\(donationId)/\(UUID().uuidString).jpg")
                
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
                            
                            newImageUrls.append(downloadUrl.absoluteString)
                            
                            let photo = Photos(donationId: donationId, imagePath: downloadUrl.absoluteString, order: index + 1)
                            print("photos \(photo.donationId)" )
                            print("photos \(photo.imagePath)" )
                            self.addFoodPhotos(photo) { result in
                                switch result {
                                case .success:
                                    print("successfullt save")
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
            
            // 2. Delete images that are no longer in the list
            for existingUrl in existingImageUrls {
                if !newImageUrls.contains(existingUrl) {
                    dispatchGroup.enter()
                    
                    // Only delete images if they are explicitly marked for removal
                    if imagesToRemove.contains(existingUrl) {
                        self.deleteImageFromStorage(photoPath: existingUrl)
                        self.deleteImage(donationId: donationId, photoPath: existingUrl)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            // 3. Update image order
            dispatchGroup.notify(queue: .main) {
                if uploadErrors.isEmpty {
                    self.updateImageOrder(donationId: donationId, newImageUrls: newImageUrls) { result in
                        completion(result)
                    }
                } else {
                    completion(.failure(uploadErrors.first!))
                }
            }
        }

    func updateImageOrder(donationId: String, newImageUrls: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var updateErrors: [Error] = []

        // Create an ordered list of images based on the newImageUrls
        let newOrder = newImageUrls.enumerated().map { (index, url) -> (String, Int) in
            return (url, index + 1)
        }

        for (url, order) in newOrder {
            dispatchGroup.enter()

            // Extract the image ID from the URL
            let imageId = extractImageId(from: url)
            
            let databaseRef = Database.database().reference().child("photos").child(imageId)
            databaseRef.updateChildValues(["order": order]) { error, _ in
                if let error = error {
                    updateErrors.append(error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if updateErrors.isEmpty {
                completion(.success(()))
            } else {
                completion(.failure(updateErrors.first!))
            }
        }
    }

    private func extractImageId(from url: String) -> String {
        return url.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    }

   


}

