import SwiftUI
import Firebase

struct ContentView: View {
    @State private var showSplashScreen = false
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
                if isAuthenticated {
                                    DashboardView()
                                } else {
                                    SignInView()
                                        .opacity(showSplashScreen ? 0 : 1)
                                }
                                if showSplashScreen {
                                    SplashScreenView()
                                        .transition(.opacity)
                                }
                if isAuthenticated {
                    BottomNavigationView()
                                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSplashScreen = false
                    }
                }
                checkAuthentication()
            }
           
            
        }
    }
    private func checkAuthentication() {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let _ = user {
                    
                    isAuthenticated = true
                } else {
                    
                    isAuthenticated = false
                }
            }
        }
   
}

struct ContentView_Preview : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
