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
    private  let collectionName = "foodrequest"
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
    
    func isRequestFoodExist(requestforId: String, completion: @escaping (Result<RequestFood, Error>) -> Void) {
        reference.child(collectionName)
            .queryOrdered(byChild: "requestforId")
            .queryEqual(toValue: requestforId)
            .observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                var existingRequest: RequestFood?
                var requestsFound = false
                
                for child in snapshot.children {
                    guard let childSnapshot = child as? DataSnapshot,
                          let request = RequestFood(snapshot: childSnapshot) else {
                        continue
                    }
                    
                    existingRequest = request
                    requestsFound = true
                    
                    if let requestedById = request.requestedBy {
                        self.userService.getUserByID(uid: requestedById) { user in
                            if let user = user {
                                existingRequest?.requestedUserDetail = user
                            } else {
                                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error fetching user details."])))
                                return
                            }
                            
                            if requestsFound {
                                if let existingRequest = existingRequest {
                                    completion(.success(existingRequest))
                                } else {
                                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request not found."])))
                                }
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "RequestedBy ID is missing."])))
                        return
                    }
                    
                    break
                }
                
                if !requestsFound {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No request found."])))
                }
            } withCancel: { error in
                completion(.failure(error))
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
        reference.child(collectionName)
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
