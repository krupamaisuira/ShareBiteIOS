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
        itemRef.setValue(["userName":_user.userName,"emailAddress":_user.emailAddress,"password" : _user.password,"mobileNumber" : _user.mobileNumber,"isDeleted":_user.isDeleted]);
    }
    
}
