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
            ZStack {
                SignInView()
                    .opacity(showSplashScreen ? 0 : 1)
                if showSplashScreen{
                    SplashScreenView()
                        .transition(.identity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSplashScreen = false
                    }
                }
            }
           
           
        }
    }
    
    private func signInfunc() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                // Handle successful sign-in
                userEmail = email
                isAuthenticated = true
            }
        }
    }
}

struct ContentView_Preview : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
