import SwiftUI

import SwiftUI

struct BottomNavigationView: View {
    @State public var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            RequestFoodDetailView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Request Food")
                }
                .tag(1)
            
            DonateFoodView()
                .tabItem {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Donate Food")
                }
                .tag(2)
            
            DonatedFoodListView()  // Assuming this is a unique view for the tab
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Donated Food")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

//
//struct TabBarItem {
//    let systemImage: String
//    let text: String
//}


