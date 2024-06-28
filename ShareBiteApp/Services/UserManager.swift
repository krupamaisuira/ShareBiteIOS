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
        itemRef.setValue(["id" : _user.id,"userName": _user.userName,"email": _user.emailAddress,
                          "mobileNumber": _user.mobileNumber,"profileDeleted": _user.profileDeleted,"notification": _user.notification,
                          "createdOn" : _user.createdOn.timeIntervalSinceNow
                         ]);
    }
    
}
