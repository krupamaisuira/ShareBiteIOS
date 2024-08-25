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
                if let childSnapshot = childSnapshot as? DataSnapshot {
                    if let dict = childSnapshot.value as? [String: Any] {
                        if let food = DonateFood(from: dict) {
                            if !food.foodDeleted, food.donatedBy == userId {
                                food.donationId = childSnapshot.key
                                tempList.append(food)
                            }
                        } else {
                            print("Failed to initialize DonateFood from dictionary: \(dict)")
                        }
                    } else {
                        print("Failed to cast childSnapshot value to dictionary: \(childSnapshot.value ?? "No value")")
                    }
                } else {
                    print("Failed to cast childSnapshot to DataSnapshot")
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
    
    func getDonationDetail(uid: String, completion: @escaping (Result<DonateFood, Error>) -> Void) {
        reference.child(collectionName).child(uid).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if snapshot.exists() {
                guard let dict = snapshot.value as? [String: Any] else {
                    print("DonateFood not found for donationId: \(uid)")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "DonateFood not found."])))
                    return
                }

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                        print("JSON Data: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")")
                     let food = try JSONDecoder().decode(DonateFood.self, from: jsonData)
                        food.donationId = uid
                        print("Decoded Food: \(food)")
                    
                    // Safely unwrap `food.donationId`
                    guard let donationId = food.donationId else {
                        print("Donation ID is nil")
                        completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Donation ID is nil."])))
                        return
                    }
                    
                    // Fetch photos asynchronously
                    self.photoService.getAllPhotosByDonationId(donationId: donationId) { result in
                        switch result {
                        case .success(let imageUris):
                            print("Photo data: \(imageUris.count)")
                            food.uploadedImageUris = imageUris
                            
                            // Fetch location asynchronously
                            self.locationService.getLocationByDonationId(uid: donationId) { result in
                                switch result {
                                case .success(let location):
                                    print("Location data: \(location.address)")
                                    food.location = location
                                    
                                    // Check if RequestFood exists
                                    self.requestFoodService.isRequestFoodExist(requestforId: donationId) { result in
                                        switch result {
                                        case .success(let existingRequest):
                                            food.requestedBy = existingRequest
                                            completion(.success(food))
                                        case .failure(let error):
                                            print("Error checking request food existence: \(error.localizedDescription)")
                                            completion(.success(food))
                                        }
                                    }
                                case .failure(let error):
                                    print("Error fetching location: \(error.localizedDescription)")
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            print("Error fetching photos: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                    
                } catch {
                    print("Error decoding DonateFood: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("Snapshot does not exist for donationId: \(uid)")
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Snapshot does not exist."])))
            }
        } withCancel: { error in
            print("DatabaseError: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    func getAllRequestFoodList(userId: String, completion: @escaping (Result<[DonateFood], Error>) -> Void) {
        let donateFoodRef = reference.child(collectionName)

        donateFoodRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            var donatedFoodList: [DonateFood] = []
            var tempList: [DonateFood] = []

            print("Snapshot value: \(snapshot.value ?? "No data")") // Debug line

            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot {
                    if let dict = childSnapshot.value as? [String: Any] {
                        if let food = DonateFood(from: dict) {
                            if !food.foodDeleted,food.status == FoodStatus.available.rawValue, food.donatedBy != userId ,Utils.isFoodExpired(bestBeforeDateStr : food.bestBefore) == 1{
                                food.donationId = childSnapshot.key
                                tempList.append(food)
                            }
                        } else {
                            print("Failed to initialize DonateFood from dictionary: \(dict)")
                        }
                    } else {
                        print("Failed to cast childSnapshot value to dictionary: \(childSnapshot.value ?? "No value")")
                    }
                } else {
                    print("Failed to cast childSnapshot to DataSnapshot")
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

}
