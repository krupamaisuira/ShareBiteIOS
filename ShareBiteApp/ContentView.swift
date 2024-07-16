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
    @State private var selectedTab = 0
    var body: some View {
        NavigationView{
            VStack {
                if isAuthenticated {
                                  HeaderView(selectedTab: $selectedTab)
                                    Divider().background(Color.blue)
                                  BottomNavigationView(selectedTab : selectedTab)
                                    Spacer()
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
