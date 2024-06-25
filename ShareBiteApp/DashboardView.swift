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
                       // Header
                       HStack {
                           
                           Text("ShareBite")
                               
                               .fontWeight(.bold)
                               .font(.system(size: 20))
                           Spacer()
                           Image("logo")
                               .resizable()
                               .frame(width: 40, height: 40)
                           Spacer()
                           
                           Image(systemName: "bell") // Bell icon using systemName
                                              .resizable()
                                              .aspectRatio(contentMode: .fit)
                                              .frame(width: 24, height: 24)
                                             
                           Image(systemName: "person.circle") // User icon using systemName
                                              .resizable()
                                              .aspectRatio(contentMode: .fit)
                                              .frame(width: 24, height: 24)
                                            

                       }
            Divider()
            .background(Color.gray)
            
            Text("Join the Fight Against Hunger")
                .font(.headline)
                .multilineTextAlignment(.center)
        
      
        
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
                                   
                                   .padding(5)
           Text("Your Donation")
                        .font(.headline)
    
         
            Divider()
            .background(Color.gray)
            
            Text("Your donation can help feed families in need. Every contribution, big or small, makes a significant impact. Together, we can fight hunger and ensure that no one goes without a meal.").padding(5)
            
            Button(action: {
                                    // Add action for donation
                                }) {
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
          
            
            Divider()
            .background(Color.gray)
            
            HStack {
                           Button(action: {
                               // Add action
                           }) {
                               Text("Home")
                           }
                Text("|")
                           Button(action: {
                               // Add action
                           }) {
                               Text("Donate Food")
                           }
                Text("|")
                           Button(action: {
                               // Add action
                           }) {
                               Text("List")
                           }
                Text("|")
                           Button(action: {
                               // Add action
                           }) {
                               Text("Request")
                           }
                Text("|")
                           Button(action: {
                               // Add action
                           }) {
                               Text("Profile")
                           }
            }
         
           
            
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
