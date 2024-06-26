//
//  Users.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-19.
//

import Foundation
struct Users :Identifiable,Codable{
    var id : String = UUID().uuidString
    var userName : String
    var emailAddress : String
    
    var mobileNumber : String
    var profileDeleted = false
    var notification = true
    var createdOn = Date()
    
}
