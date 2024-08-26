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
    
    func requestFood(model: RequestFood, completion: @escaping (Result<Void, Error>) -> Void) {
      
        guard let newItemKey = reference.child(collectionName).childByAutoId().key else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate new item key."])))
            return
        }      
        model.requestId = newItemKey

        reference.child(collectionName).child(newItemKey).setValue(model.toMapUpdate()) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func isRequestFoodExist(requestforId: String, completion: @escaping (Result<RequestFood, Error>) -> Void) {
        print("request for id \(requestforId)")
        reference.child(collectionName)
            .queryOrdered(byChild: "requestforId")
            .queryEqual(toValue: requestforId)
            .observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                var existingRequest: RequestFood?
                var requestsFound = false
                print("request for donation detail \(snapshot.value)")
                for child in snapshot.children {
                    guard let childSnapshot = child as? DataSnapshot,
                          let request = RequestFood(snapshot: childSnapshot) else {
                        continue
                    }
                    
                    existingRequest = request
                    requestsFound = true
                    
                    if let requestedById = request.requestedBy {
                        print("inside this to call userid \(requestedById)")
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

    func requestFoodCancel(uid: String, cancelBy: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let updates: [String: Any] = [
            "cancelon": Utils.getCurrentDatetime(),
            "cancelby": cancelBy
        ]

        reference.child(collectionName).child(uid).updateChildValues(updates) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
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
    func fetchDonationRequests(userId: String, completion: @escaping ([String]?, String?) -> Void) {
       
        var donationIds: [String] = []

        reference.child(collectionName).queryOrdered(byChild: "requestedBy").queryEqual(toValue: userId)
            .observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let model = RequestFood(snapshot: childSnapshot),
                       model.requestforId != nil,
                       model.cancelon == nil {
                        donationIds.append(model.requestforId!)
                    }
                }
                completion(donationIds, nil)
            }) { error in
                completion(nil, error.localizedDescription)
            }
    }

}
