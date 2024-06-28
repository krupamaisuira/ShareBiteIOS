//
//  UserManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-19.
//

import Foundation
import FirebaseDatabase
import Firebase

class UserManager : ObservableObject{
    
    private let database = Database.database().reference();
    
    private let _collection = "users";
    func registerUser(_user: Users){
        let itemRef = database.child(_collection).child(_user.id)
        itemRef.setValue(["userid" : _user.id,"username": _user.username,"email": _user.email,
                          "mobilenumber": _user.mobilenumber,"profiledeleted": _user.profiledeleted,"notification": _user.notification,
                          "createdon" : _user.createdon.timeIntervalSinceNow
                         ]);
    }
    func fetchUserByUserID(withID id: String, completion: @escaping (SessionUsers?) -> Void) {
        let usersRef = database.child("users")
        
        usersRef.child(id)
            .observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    print("Snapshot exists: \(snapshot)")
                    
                    if let userData = snapshot.value as? [String: Any] {
                        print("data parse started")
                       
                        let username = userData["username"] as? String ?? ""
                        let email = userData["email"] as? String ?? ""
                        let notification = userData["notification"] as? Bool ?? true
                        
                       
                        let user = SessionUsers(id: id,
                                                username: username,
                                                email: email,
                                                notification: notification)
                        
                        completion(user)
                    } else {
                        print("Failed to parse user data for id: \(id)")
                        completion(nil)
                    }
                } else {
                    print("No user found for id: \(id)")
                    completion(nil)
                }
            }
    }




    
}
