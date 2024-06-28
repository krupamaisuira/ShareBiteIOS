//
//  Users.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-19.
//

import Foundation
struct Users :Identifiable,Codable{
    var id : String
    var username : String
    var email : String    
    var mobilenumber : String
    var profiledeleted = false
    var notification = true
    var createdon = Date()
    
}
struct SessionUsers :Identifiable,Codable{
    var id : String
    var username : String
    var email : String
    var notification = true
}
