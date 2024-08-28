import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var userName: String = ""
    @State private var mobileNumber: String = ""
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isTermsAccepted: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isConfPasswordVisible: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(10)
                    .padding(.top,50)
                
                VStack(spacing: 15) {
                    TextField("User Name", text: $userName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
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
                    
                    HStack {
                        if isConfPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                                .padding()
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .padding()
                        }
                        Button(action: {
                            isConfPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .padding(10)
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
               
                HStack {
                    Button(action: {
                        isTermsAccepted.toggle()
                    }) {
                        Image(systemName: isTermsAccepted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isTermsAccepted ? .green : .gray)
                    }
                    Text("I accept the terms and conditions.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    registerUser()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Got a profile?")
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) {
                        Text("Sign In")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 120)
            }
            .background(Color.white)
            .navigationBarHidden(true) // Hide the navigation bar
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Registration Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true) // Ensure the back button is hidden
    }
    
    private func registerUser() {
        if userName.isEmpty || mobileNumber.isEmpty || emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty {
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
        if !Utils.isPasswordValid(password) {
            showAlert(message: "Password must contain at least one letter and one digit.")
            return
        }
        if password != confirmPassword {
            showAlert(message: "Passwords do not match.")
            return
        }
        if !isTermsAccepted {
            showAlert(message: "Please accept the terms and conditions.")
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    let errorCode = error.code
                    switch errorCode {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        showAlert(message: "The email address is already in use.")
                    case AuthErrorCode.weakPassword.rawValue:
                        showAlert(message: "The password is too weak.")
                    default:
                        showAlert(message: error.localizedDescription)
                    }
                    return
                }
                if let user = authResult?.user {
                    let userID = user.uid
                    let newUser = Users(id: userID, username: userName, email: emailAddress, mobilenumber: mobileNumber)
                    UserManager().registerUser(_user: newUser) { success in
                        if success {
                            navigateToSignIn = true
                        } else {
                            showAlert(message: "Failed to register user in the system.")
                        }
                    }
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
