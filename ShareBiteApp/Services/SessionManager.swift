//
//  SessionManager.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-26.
//

import Foundation
class SessionManager {
    static let shared = SessionManager()
    
    private let userManager = UserManager()
    
    private var currentUser: SessionUsers?
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
//    func loginUser(email: String, completion: @escaping (Bool) -> Void) {
//        userManager.fetchUserByEmail(email: email) { [weak self] (user) in
//            if let user = user {
//
//                self?.currentUser = user
//                completion(true)
//            } else {
//
//                self?.currentUser = nil
//                completion(false)
//            }
//        }
//    }
//
    func logoutUser() {
        currentUser = nil
       
    }
    
    func getCurrentUser() -> SessionUsers? {
        return currentUser
    }
}
