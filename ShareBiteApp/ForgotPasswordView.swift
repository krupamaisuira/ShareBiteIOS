import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(10)
                
                Text("Forgotten password")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom, 20)
                
                Spacer()
                
                Text("Fill your email address to receive an email and reset your password")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(20)
                
                VStack(spacing: 15) {
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    forgotPassword()
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                
                HStack {
                    NavigationLink(destination: SignInView()) {
                        Text("Back to Sign In")
                            .foregroundColor(.blue)
                            .underline(true, color: .blue)
                    }
                }
                .padding(.bottom, 200)
            }
            .background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Password Reset Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func forgotPassword() {
        if email.isEmpty {
            self.alertMessage = "Email Address is invalid."
            self.showAlert = true
            return
        } 
        else if !Utils.isValidEmail(email) {
            self.alertMessage = "Please enter a valid Email Address."
            self.showAlert = true
            
            return
        }
        
        else {
            Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                } else {
                    self.alertMessage = "Password reset email sent successfully."
                    self.showAlert = true
                    self.email = ""
                }
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
