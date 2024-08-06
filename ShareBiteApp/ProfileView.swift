//
//  ProfileView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-28.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var isLoggedOut = false
    @State private var showConfirmationDialog = false
    @StateObject private var userManager = UserManager()
    @State private var notificationsEnabled = false
    
    var body: some View {
        NavigationView {
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
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("My settings")
                    .font(.title2)
                    .bold()
                    .padding(.top, 30)
                
                Divider()
                    .background(Color.gray)
                
                HStack {
                    Text("Activate notifications")
                    Spacer()
                    Toggle(isOn: $notificationsEnabled) {
                        Text("")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color(.systemGreen)))
                    .padding(.trailing)
                }
                .onAppear {
                    notificationsEnabled = sessionManager.getCurrentUser()?.notification ?? false
                }
                .onChange(of: notificationsEnabled) { newValue in
                    userManager.notificationSetting(notification: newValue)
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
                    Spacer()
                }
                .padding()
                
                Divider()
                    .background(Color.gray)
                
                Text("Your donation can help feed families in need. Every contribution, big or small, makes a significant impact. Together, we can fight hunger and ensure that no one goes without a meal.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Spacer() // Pushes content to the top
            }
            .padding()
            .onAppear {
                // Ensure the view updates when the user data changes
                if let user = sessionManager.getCurrentUser() {
                    notificationsEnabled = user.notification
                }
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
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
