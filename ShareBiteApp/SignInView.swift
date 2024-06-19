//
//  SignInView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-12.
//

import SwiftUI

struct SignInView: View {
    @State private var  username :String = ""
    @State private var  password :String = ""
    @State private var  isPasswordVisible = false
    var body: some View {
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 200)
                .padding(10)
            Text("What are your Login Details")
                        .font(.system(size: 22)) // Set font size to 10
                        .foregroundColor(.black)
                        .bold()
            Form {
                TextField("Your Email Address",text: $username)
                
                
                HStack {
                              if isPasswordVisible {
                                  TextField("Password", text: $password)
                              } else {
                                  SecureField("Password", text: $password)
                              }
                              Button(action: {
                                  isPasswordVisible.toggle()
                              }) {
                                  Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                      .foregroundColor(.gray)
                              }
                }
            }.frame(maxHeight: 150)
                .background(Color.white)
            
            Text("Forgot Password?")
                .padding()
            
            Button(action: {
               
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
            
            HStack{
                Text("Don't  have a profile?")
                Text("Create new one").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).underline(true, color: .blue)
                
            }.padding(.bottom, 170)

                        
                        
                
        }
    }
}

#Preview {
    SignInView()
}
