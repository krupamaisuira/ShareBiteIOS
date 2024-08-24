//
//  LocationManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-20.
//

import FirebaseDatabase
protocol ListLocationOperationCallback {
    func onSuccess(_ location: Location)
    func onFailure(_ error: String)
}

class LocationService {
    private var reference: DatabaseReference
    private  let collectionName = "location"

    init() {
        self.reference = Database.database().reference()
    }

    func addLocation(_ model: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let newItemKey = reference.child(collectionName).childByAutoId().key
        
        model.locationId = newItemKey
        
        reference.child(collectionName).child(newItemKey!).setValue(model.toMap()) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteLocationByDonationID(donationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
       
        reference.child(collectionName)
            .queryOrdered(byChild: "donationId")
            .queryEqual(toValue: donationId)
            .observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    if let firstMatch = snapshot.children.allObjects.first as? DataSnapshot,
                       let locationId = firstMatch.key as String? {
                        self.reference.child(self.collectionName).child(locationId).child("locationdeleted").setValue(true) { error, _ in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve location ID."])))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found with the provided donation ID."])))
                }
            } withCancel: { error in
                completion(.failure(error))
            }
    }




}

