//
//  ContentView.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-05.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var showSplashScreen = true
    @State private var isShowingSignUP = false
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @State private var isAuthenticated = false
    @State private var userEmail = ""
    @State private var email : String = ""
    @State private var password : String = ""
    
    var body: some View {
        NavigationView{
            if isAuthenticated{
                DashboardView(userEmail: userEmail)
            }else
            {
                VStack{
                    
                    Text("Welcome to my app")
                    TextField("Email",text : $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal,40)
                    
                    SecureField("password",text : $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal,40)
                    
                    Button(action: signInfunc){
                        Text("Signin")
                        
                    }.buttonStyle(.bordered).background(Color.cyan).foregroundColor(.black).padding()
                    
                    
                    Button(action : {isShowingSignUP = true})
                    {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(width:240,height: 60)
                            .background(Color.white)
                            .cornerRadius(15.0)
                            .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(Color.blue,lineWidth:2))
                        
                    }
                }
                .padding()
                .alert(isPresented:$isShowingAlert){
                    Alert(title:Text("Error"),message: Text(alertMessage),dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented:$isShowingSignUP){
                    SignUpView()
                }
            }
        }

    }
    private func signInfunc(){
        Auth.auth().signIn(withEmail: email, password: password){
            authResult,error in
            if let error = error{
                alertMessage = error.localizedDescription
                isShowingAlert = true
            }
            else
            {// Handlee successfull signup
                userEmail = email
                isAuthenticated = true
            }
        }
    }
}

struct ContentView_Preview : PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}

//        ZStack {
//            SignInView()
//                .opacity(showSplashScreen ? 0 : 1)
//            if showSplashScreen{
//                SplashScreenView()
//                    .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
//            }
//        }
//        .onAppear{
//            DispatchQueue.main.asyncAfter(deadline: .now()+3){
//                withAnimation{showSplashScreen = false}
//            }
//        }
