//
//  ProfileView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-28.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var sessionManager = SessionManager.shared
    @State private var isLoggedOut = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) { // Align VStack content to the leading edge
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                        
                        Text("Krupa Maisuria")
                            .font(.title)
                            .padding(.leading, 10) // Add padding to adjust the position of the text
                    }
                    .padding(5)
                    
                    Divider()
                        .background(Color.gray)
                    
                    Text("Manage your account information and preferences to personalize your experience.")
                        .padding(10)
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                    
                    Text("My settings")
                        .font(.title2)
                        .bold()
                        .padding(.top, 30)
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        Text("Activate notifications")
                        
                        Spacer() // Push Toggle to the right edge
                        Toggle(isOn: .constant(true)) {
                            // No action needed here
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color(.systemGreen)))
                        .padding(.trailing)
                    }
                    .padding()
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        Text("Change Password")
                        
                        Spacer() // Push text to the right edge
                    }
                    .padding()
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        Text("Delete Profile")
                        
                        Spacer() // Push text to the right edge
                    }
                    .padding()
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        
                        Button(action: {
                                      sessionManager.logoutUser()
                                      isLoggedOut = true
                                        }) {
                                            Text("Log Out")
                                                .foregroundColor(.black)
                                        }
                                       
                        
                       
                        
                        Spacer() // Push text to the right edge
                    }
                    .padding()
                    
                    Divider()
                        .background(Color.gray)
                    
                    Text("Your donation can help feed families in need. Every contribution, big or small, makes a significant impact. Together, we can fight hunger and ensure that no one goes without a meal.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding() // Add padding to VStack content
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(
                            NavigationLink(
                                destination: SignInView(),
                                isActive: $isLoggedOut,
                                label: { EmptyView() }
                            )
                        )
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
