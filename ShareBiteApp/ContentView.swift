import SwiftUI
import Firebase

struct ContentView: View {
    @State private var showSplashScreen = false
    @State private var selectedTab = 0
    @StateObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if sessionManager.isLoggedIn {
                    HeaderView()
                    Divider().background(Color.blue)
                    BottomNavigationView(selectedTab: selectedTab)
                } else {
                    SignInView()
                        .opacity(showSplashScreen ? 0 : 1)
                }
                
                if showSplashScreen {
                    SplashScreenView()
                        .transition(.opacity)
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
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
            if let user = user {
                sessionManager.loginUser(userid: user.uid) { success in
                    // Handle successful login
                    print("User logged in: \(success)")
                }
            } else {
                // Handle user not logged in
                print("No user logged in")
                sessionManager.logoutUser()
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .light) // Add environment settings if needed
    }
}
