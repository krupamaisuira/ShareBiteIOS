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
    @State private var showConfirmationDialog = false
    @StateObject private var userManager = UserManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                        
                        if let currentUser = sessionManager.getCurrentUser() {
                                                    Text(currentUser.username)
                                                        .font(.title)
                                                        .padding(.leading, 10)
                                                } else {
                                                    Text("Unknown User")
                                                        .font(.title)
                                                        .padding(.leading, 10)
                                                }
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
                        
                        Spacer()
                        Toggle(isOn: .constant(true)) {
                           
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color(.systemGreen)))
                        .padding(.trailing)
                    }
                    .padding()
                    Divider()
                        .background(Color.gray)
                    
                    NavigationLink(destination: ChangePasswordView()) {
                                            HStack {
                                                Text("Change Password")
                                                    .foregroundColor(.black)
                                                
                                            }
                                        }
                    .padding()
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                                            Button(action: {
                                                showConfirmationDialog = true
                                            }) {
                                                Text("Delete Profile")
                                                    .foregroundColor(.black)
                                            }
                                            .padding()
                                            .alert("Are you sure you want to delete your profile?", isPresented: $showConfirmationDialog) {
                                                Button("Cancel", role: .cancel) {}
                                                Button("OK") {
                                                    userManager.deleteProfile()
                                                    sessionManager.logoutUser()
                                                    isLoggedOut = true
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                    
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
