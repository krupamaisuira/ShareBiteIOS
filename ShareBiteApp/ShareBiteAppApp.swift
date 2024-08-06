//
//  ShareBiteAppApp.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-05.
//

import SwiftUI
import Firebase
import GooglePlaces

@main
struct ShareBiteAppApp : App {
    init(){
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyDP8MyqY0fBpjk6CUVHlDatuD9EK-QTYsM")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
