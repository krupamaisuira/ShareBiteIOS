//
//  ChangePasswordView.swift
//  ShareBiteApp
//
//  Created by User on 2024-07-02.
//

import SwiftUI
import Firebase

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToProfile: Bool = false
    @StateObject private var sessionManager = SessionManager.shared
    @State private var passwordChanged: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo") // Replace with your logo image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(10)
                
                Text("Change Password")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("Please enter your new password and confirm it by entering it again.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(20)
                
                VStack(spacing: 15) {
                    ToggleableSecureField(text: $currentPassword, placeholder: "Current Password")
                    ToggleableSecureField(text: $newPassword, placeholder: "New Password")
                    ToggleableSecureField(text: $confirmPassword, placeholder: "Confirm New Password")
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    changePassword()
                }) {
                    Text("Change Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                
                NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) {
                    EmptyView()
                }
                
                Button(action: {
                    navigateToProfile = true // Activate navigation to profile view
                }) {
                    Text("Back to Profile")
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Change Password Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Reset states when view appears
            currentPassword = ""
            newPassword = ""
            confirmPassword = ""
            showAlert = false
            passwordChanged = false
        }
    }
    
    private func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            self.alertMessage = "Please fill in all fields."
            self.showAlert = true
            return
        }
        
        if newPassword != confirmPassword {
            self.alertMessage = "New passwords do not match."
            self.showAlert = true
            return
        }
        
        let currentUser = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: currentUser?.email ?? "", password: currentPassword)
        
        currentUser?.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            } else {
                currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    } else {
                        sessionManager.logoutUser()
                        self.alertMessage = "Password changed successfully."
                        self.showAlert = true
                        self.navigateToProfile = true // Navigate to profile view
                        self.passwordChanged = true // Activate navigation to sign-in view
                    }
                }
            }
        }
    }
}

struct ToggleableSecureField: View {
    @Binding var text: String
    var placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            Button(action: {
                self.isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
