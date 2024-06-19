//
//  SplashScreenView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-12.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 200)
                .padding(23)
            Text("Fight Hunger Together")
                        .font(.system(size: 22)) // Set font size to 10
                        .foregroundColor(.white)
                        .padding(8)// Set text color
                        .background(Color.teal)
                        
                
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SplashScreenView()
}
