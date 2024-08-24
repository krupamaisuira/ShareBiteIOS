//
//  DonateFoodManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import Foundation
import Firebase
import FirebaseStorage



class DonateFoodService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let locationService = LocationService()
    private let photoService = PhotoService()
    private let requestFoodService = RequestFoodService()
    
    private let collectionName = "donatefood"
    
    private var reference: DatabaseReference
    
    init() {
        self.reference = Database.database().reference()
    }
    func donateFood(_ food: DonateFood, completion: @escaping (Result<Void, Error>) -> Void) {
        let newItemKey = reference.child(collectionName).childByAutoId().key
        
       
        food.donationId = newItemKey
        
        reference.child(collectionName).child(newItemKey!).setValue(food.toMap()) { error ,_ in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let donationId = food.donationId else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate donation ID"])))
                return
            }
            guard let location = food.location else {
                       completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location is missing"])))
                       return
                   }
            self.addLocationForDonatedFood(donationId: donationId, location: location ) { result in
                switch result {
                case .success:
                    // Safely unwrap and handle optional image array
                    if let images = food.saveImage {
                        self.photoService.uploadImages(donationId: donationId, imageUris: images) { result in
                            switch result {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        // Handle the case where there are no images
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    private func addLocationForDonatedFood(donationId: String, location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let locationData = Location(donationId: donationId, address: location.address, latitude: location.latitude, longitude: location.longitude)
        locationService.addLocation(locationData) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getAllDonatedFood(userId: String, completion: @escaping (Result<[DonateFood], Error>) -> Void) {
        let donateFoodRef = reference.child(collectionName)
        
        donateFoodRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            var donatedFoodList: [DonateFood] = []
            var tempList: [DonateFood] = []

            print("Snapshot value: \(snapshot.value ?? "No data")") // Debug line
            
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let food = DonateFood(snapshot: childSnapshot) {
                    print("Fetched food: \(food)") // Debug line
                    
                    print("Food deleted: \(food.foodDeleted), Donated by: \(food.donatedBy), Expected userId: \(userId)")
                    if !food.foodDeleted, food.donatedBy == userId {
                        food.donationId = childSnapshot.key
                        tempList.append(food)
                    }
                } else {
                    print("Failed to initialize DonateFood from snapshot: \(childSnapshot)")
                }
            }

            if tempList.isEmpty {
                print("temp list empty")
                completion(.success(donatedFoodList))
                return
            }

            let dispatchGroup = DispatchGroup()

            for food in tempList {
                if let donationId = food.donationId {
                    dispatchGroup.enter()
                    self.photoService.getAllPhotosByDonationId(donationId: donationId) { result in
                        switch result {
                        case .success(let imageUris):
                            food.uploadedImageUris = imageUris
                            donatedFoodList.append(food)
                        case .failure(let error):
                            print("Error fetching photos: \(error.localizedDescription)")
                        }
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(.success(donatedFoodList))
            }
        } withCancel: { error in
            print("Error fetching data: \(error.localizedDescription)") // Debug line
            completion(.failure(error))
        }
    }

//    func deleteDonatedFood(donationid: String, completion: @escaping (Result<Void, Error>) -> Void) {
//       
//        reference.child(collectionName).child(donationid).child("fooddeleted").setValue(true) { error, _ in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                self.locationService.deleteLocationByDonationID(donationId:donationid){ result in
//                    switch result {
//                    case .success:
//                        completion(.success(()))
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
    func deleteDonatedFood(donationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            
            reference.child(collectionName).child(donationId).child("foodDeleted").setValue(true) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    
    
    
}
