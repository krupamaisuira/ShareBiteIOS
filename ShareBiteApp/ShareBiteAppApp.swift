//
//  ShareBiteAppApp.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-05.
//

import SwiftUI
import Firebase

@main
struct ShareBiteAppApp : App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
