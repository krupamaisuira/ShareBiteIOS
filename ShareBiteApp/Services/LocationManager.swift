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




    func deleteLocationByDonationID(_ donationId: String, callback: OperationCallback?) {
        reference.child(collectionName)
            .queryOrdered(byChild: "donationId")
            .queryEqual(toValue: donationId)
            .observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    if let firstMatch = snapshot.children.allObjects.first as? DataSnapshot {
                        let locationId = firstMatch.key
                        self.reference.child(self.collectionName).child(locationId).child("locationdeleted").setValue(true) { error, _ in
                            if let error = error {
                                callback?.onFailure(error.localizedDescription)
                            } else {
                                callback?.onSuccess()
                            }
                        }
                    }
                } else {
                    callback?.onFailure("No location found with the provided donation ID.")
                }
            } withCancel: { error in
                callback?.onFailure(error.localizedDescription)
            }
    }

  

    func updateLocation(_ model: Location, callback: OperationCallback?) {
        // Make a mutable copy of the model
//        var mutableModel = model
//        mutableModel.updatedOn = Utils.getCurrentDatetime()
        
        // Proceed with updating the Firebase database
        reference.child(collectionName).child(model.locationId ?? "").updateChildValues(model.toMapUpdate()) { error, _ in
            if let error = error {
                callback?.onFailure(error.localizedDescription)
            } else {
                callback?.onSuccess()
            }
        }
    }

}

