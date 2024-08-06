import SwiftUI

struct BottomNavigationView: View {
    @State public var selectedTab : Int
    
    let tabBarItems = [
        TabBarItem(systemImage: "house", text: "Dashboard"),
        TabBarItem(systemImage: "cart", text: "Request Food"),
        TabBarItem(systemImage: "arrow.up.circle.fill", text: "Donate Food"),
        TabBarItem(systemImage: "list.bullet", text: "Donated Food"),
        TabBarItem(systemImage: "person", text: "Profile")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tag(0)
                
                request_food()
                    .tag(1)
                
                DashboardView()
                    .tag(2)
                
                ProfileView()
                    .tag(3)
                
                ProfileView()
                    .tag(4)
            }
            .accentColor(.blue)
            .padding(.top,8)
            Divider() .background(Color.blue)
            
            HStack {
                ForEach(0..<tabBarItems.count) { index in
                    Button(action: {
                        self.selectedTab = index
                    }) {
                        VStack {
                            Image(systemName: self.tabBarItems[index].systemImage)
                            Text(self.tabBarItems[index].text)
                                .font(.footnote)
                        }
                        //.frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(self.selectedTab == index ? .blue : .gray)
                    }
                }
            }
            .background(Color.white)
        }
    }
}

struct TabBarItem {
    let systemImage: String
    let text: String
}


