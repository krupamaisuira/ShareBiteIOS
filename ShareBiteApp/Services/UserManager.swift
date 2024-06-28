//
//  UserManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-19.
//

import Foundation
import FirebaseDatabase

class UserManager : ObservableObject{
    
    private let database = Database.database().reference();
    
    func registerUser(_user: Users){
        let itemRef = database.child("users").child(_user.id)
        itemRef.setValue(["id" : _user.id,"username": _user.username,"email": _user.email,
                          "mobilenumber": _user.mobilenumber,"profiledeleted": _user.profiledeleted,"notification": _user.notification,
                          "createdon" : _user.createdon.timeIntervalSinceNow
                         ]);
    }
    
    func fetchUserByEmail(email: String, completion: @escaping (SessionUsers?) -> Void) {
        let usersRef = Firestore.firestore().collection("users")
        
        usersRef.whereField("email", isEqualTo: email)
                .whereField("profileDeleted", isEqualTo: false)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching user: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    if let documents = querySnapshot?.documents {
                        if documents.count == 1 {
                            let document = documents[0]
                            let userData = document.data()
                            
                            
                            let user = SessionUsers(id: document.documentID,
                                             username: userData["username"] as? String ?? "",
                                             email: userData["email"] as? String ?? "",
                                             notification: userData["notification"] as? Bool ?? true)
                            
                            completion(user)
                        } else {
                            print("More than one document found or no documents matched the query")
                            completion(nil)
                        }
                    } else {
                        print("No documents found")
                        completion(nil)
                    }
                }
    }

    
}
