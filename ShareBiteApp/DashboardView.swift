//
//  DashboardView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-12.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var sessionManager = SessionManager.shared
    var body: some View {
        NavigationView {
            VStack{
                
                HStack {
                    Text("ShareBite")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Spacer()
                    
                    Image(systemName: "bell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    
                    
                }
                Divider()
                    .background(Color.gray)
                
                Text("Join the Fight Against Hunger")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                if let username = sessionManager.getCurrentUser()?.username {
                    Text(username)
                        .font(.body)
                }
                
                HStack {
                    VStack {
                        Text("0")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Donations")
                            .fontWeight(.bold)
                        Image(systemName: "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24).padding(7)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    
                    Spacer()
                    
                    VStack {
                        Text("0")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Collections")
                            .fontWeight(.bold)
                        Image(systemName: "cart")
                        
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24).padding(7)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                }
                .padding()
                
                .cornerRadius(10)
                Text("We encourage diversity in donations to ensure that we can meet the nutritional needs and dietary restrictions of everyone we serve.")
                    .padding(12)
                
                Text("Your Donation")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                
                
                Divider()
                    .background(Color.gray)
                
                Text("Your donation can help feed families in need. Every contribution, big or small, makes a significant impact. Together, we can fight hunger and ensure that no one goes without a meal.").padding(5)
                
                NavigationLink(destination: ProfileView()) {
                    Text("Donate Food")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                .padding()
                .cornerRadius(10)
                
                Text("News")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom, 7)
                
                Divider()
                    .background(Color.gray)
                
                HStack {
                    Image("food")
                        .resizable()
                        .frame(width: 140, height: 90)
                    Image("food")
                        .resizable()
                        .frame(width: 140, height: 90)
                }.padding(4)
            }
            
        }
    }
}

struct DashboardView_Preview : PreviewProvider{
    static var previews : some View {
        DashboardView()
    }
    
}
