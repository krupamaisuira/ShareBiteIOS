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

            self.addLocationForDonatedFood(donationId: donationId, location: food.location) { result in
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


    
  
    
    
    
    
   
}
