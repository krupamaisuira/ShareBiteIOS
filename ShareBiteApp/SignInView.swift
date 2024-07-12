import SwiftUI
import Firebase

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToDashboard: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(10)
                
                Text("What are your Login Details")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .padding()
                        } else {
                            SecureField("Password", text: $password)
                                .padding()
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .padding(10)
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                HStack {
                    Text("Forgot Password?")
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Reset it here")
                            .foregroundColor(.blue)
                            .underline(true, color: .blue)
                    }
                }
                Button(action: {
                    loginUser()
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Don't have a profile?")
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Create new one")
                            .foregroundColor(.blue)
                            .underline(true, color: .blue)
                    }
                }
                .padding(.bottom, 200)
            }
            .background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid email address and password"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .fullScreenCover(isPresented: $navigateToDashboard, content: {
                            DashboardView()
                                .onDisappear() {
                                  
                                    navigateToDashboard = false
                                }
                        })
        }
    }
    
    private func loginUser() {
        if email.isEmpty || password.isEmpty {
            showAlert(message: "Please fill in all fields.")
            return
        }
        if !Utils.isValidEmail(email) {
            showAlert(message: "Please enter a valid Email Address.")
            return
        }
                
        if !Utils.isPasswordValid(password) {
            showAlert(message: "Password must contain at least one letter and one digit.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else if let authResult = authResult {
                let userID = authResult.user.uid
                print(userID)
                SessionManager.shared.loginUser(userid: userID) { success in
                    if success {
                        self.navigateToDashboard = true
                    } else {
                        self.showAlert(message: "Failed to log in. Please try again later.")
                    }
                }
            } else {
                self.showAlert(message: "Authentication failed. Please try again later.")
            }
        }
    }

    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
