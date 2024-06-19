//
//  DashboardView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-12.
//

import SwiftUI

struct DashboardView: View {
    var userEmail : String
    var body: some View {
        VStack{
            Text("Welcome to home page : ")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            
            Text("Logged by : \(userEmail)")
                .font(.title)
                .padding()
        }
    }
}

struct DashboardView_Preview : PreviewProvider{
    static var previews : some View {
        DashboardView(userEmail: "test@gmaail.com")
    }
    
}
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}


//private func registerUser() {
//    if userName.isEmpty || mobileNumber.isEmpty || emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty {
//        showAlert(message: "Please fill in all fields.")
//        return
//    }
//    
//    if password != confirmPassword {
//        showAlert(message: "Passwords do not match.")
//        return
//    }
//    if isTermsAccepted {
//        showAlert(message: "Please accept the terms and conditions.")
//        return
//    }
//    let newUser = Users(userName: userName, emailAddress: emailAddress, password: password, mobileNumber: mobileNumber)
//    userManager.registerUser(_user: newUser)
//    
//    
//    navigateToSignIn = true
//}
//
//private func showAlert(message: String) {
//    alertMessage = message
//    showAlert = true
//}
