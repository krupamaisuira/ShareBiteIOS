//
//  RequestFoodManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-20.
//

import Foundation
import Firebase


protocol OperationCallbackList {
    associatedtype T
    func onSuccess<T>(_ result: [T])
    func onFailure(_ error: String)
}
class RequestFoodService {
    
    private let reference: DatabaseReference
    private static let collectionName = "foodrequest"
    private let userService: UserManager

    init() {
        self.reference = Database.database().reference()
        self.userService = UserManager()
    }
    
//    func requestFood(model: RequestFood, callback:  OperationCallback) {
//        let newItemKey = reference.child(Self.collectionName).childByAutoId().key
//        model.requestId = newItemKey
//        guard let newItemKey = newItemKey else {
//            callback.onFailure("Failed to generate new item key.")
//            return
//        }
//        
//        reference.child(Self.collectionName).child(newItemKey).setValue(model.toMapUpdate()) { error, _ in
//            if let error = error {
//                callback.onFailure(error.localizedDescription)
//            } else {
//                callback.onSuccess()
//            }
//        }
//    }
    
    func isRequestFoodExist(model: RequestFood, callback: any OperationCallbackList) {
        reference.child(Self.collectionName)
            .queryOrdered(byChild: "requestforId")
            .queryEqual(toValue: model.requestforId)
            .observeSingleEvent(of: .value) { (snapshot : DataSnapshot) in
                var dataFound = false
                var existingRequest: RequestFood?

                for child in snapshot.children {
                    guard let childSnapshot = child as? DataSnapshot,
                          let request = RequestFood(snapshot: childSnapshot) else {
                        continue
                    }

                    existingRequest = request
                    dataFound = true

                    // Adjust to handle the closure-based UserCallback
                    self.userService.getUserByID(uid: request.requestedBy ?? "<#default value#>",
                                                 onSuccess: { user in
                                                     existingRequest?.requestedUserDetail = user
                                                     if dataFound, let existingRequest = existingRequest {
                                                         callback.onSuccess([existingRequest])
                                                     }
                                                 },
                                                 onFailure: { error in
                                                     callback.onFailure(error)
                                                 })

                    // Break out of the loop once we have found and processed a request
                    return
                }

                if !dataFound {
                    callback.onSuccess([])
                }
            } withCancel: { error in
                callback.onFailure(error.localizedDescription)
            }
    }


        
//    
//    func requestFoodCancel(uid: String, cancelby: String, callback: OperationCallback) {
//        let updates = [
//            "cancelon": Utils.getCurrentDatetime(),
//            "cancelby": cancelby
//        ]
//        
//        reference.child(Self.collectionName).child(uid).updateChildValues(updates) { error, _ in
//            if let error = error {
//                callback.onFailure(error.localizedDescription)
//            } else {
//                callback.onSuccess()
//            }
//        }
//    }
    
    func fetchDonationRequests(userId: String, callback: @escaping ([String]) -> Void) {
        reference.child(Self.collectionName)
            .queryOrdered(byChild: "requestedBy")
            .queryEqual(toValue: userId)
            .observeSingleEvent(of: .value) { snapshot in
                var donationIds = [String]()
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let model = RequestFood(snapshot: child),
                          let requestforId = model.requestforId,
                          model.cancelon == nil else {
                        continue
                    }

                    donationIds.append(requestforId)
                }

                callback(donationIds)
            } withCancel: { error in
                print(error.localizedDescription) // Log the error or use another callback for failure
            }
    }


}
