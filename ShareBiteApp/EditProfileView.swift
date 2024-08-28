import SwiftUI

struct EditProfileView: View {
    @State private var userName: String = ""
    @State private var mobileNumber: String = ""
    @State private var emailAddress: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn = false
    @State private var navigateToProfile: Bool = false
    private let userManager = UserManager()
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var userdetail : Users? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(10)
                    .padding(.top,50)
                
                Text("Edit Your Profile")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.blue)

                Text("By editing your profile, you agree to our updated terms and conditions and privacy policy.")
                    .font(.system(size: 12))
                    .padding(.top, 10)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 15) {
                    TextField("User Name", text: $userName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.top,10)
                    
                    TextField("Mobile Number", text: $mobileNumber)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        .onChange(of: mobileNumber) { newValue in
                            mobileNumber = newValue.filter { $0.isNumber }
                        }
                    
                    TextField("Email Address", text: $emailAddress)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                   
                }
                .padding(.horizontal, 30)
                
                
                Button(action: {
                    updateProfile()
                }) {
                    Text("Update Profile")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                
                HStack {
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 120)
                NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) {
                                   EmptyView()
                               }
            }
            .background(Color.white)
            .navigationBarHidden(true) // Hide the navigation bar
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Profile Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
           
            .onAppear {
                loadUserDetail()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func updateProfile() {
        if userName.isEmpty || mobileNumber.isEmpty || emailAddress.isEmpty  {
            showAlert(message: "Please fill in all fields.")
            return
        }
        if mobileNumber.count != 10 {
            showAlert(message: "Mobile Number should be 10 digits.")
            return
        }
        if !Utils.isValidEmail(emailAddress) {
            showAlert(message: "Please enter a valid Email Address.")
            return
        }
       
        let updatedUser = Users(id: userdetail?.id ?? "" ,username: userName, email: emailAddress, mobilenumber: mobileNumber)
        let userid = userdetail?.id ?? ""
        
        userManager.updateUser(updatedUser) { success in
            if success {
                print("Profile updated successfully")
                SessionManager.shared.loginUser(userid: userid) { success in
                    if success {
                        self.navigateToProfile = true
                    } else {
                        self.showAlert(message: "Failed to log in. Please try again later.")
                    }
                }
            } else {
                showAlert(message: "Failed to update profile.")
            }
        }
    }
    
    private func loadUserDetail() {
        if let userId = sessionManager.getCurrentUser()?.id {
            userManager.getUserByID(uid: userId) { users in
                if let user = users {
                    userdetail = user
                    userName = user.username
                    mobileNumber = user.mobilenumber
                    emailAddress = user.email
                } else {
                    showAlert(message: "Something happened. Please try again later.")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
