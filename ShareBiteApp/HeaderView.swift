import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: Int
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 45, height: 45)
            Text("ShareBite")
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            Spacer()
            
            Image(systemName: "bell")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            
            Button(action: {
                self.selectedTab = 4 // Set Profile tab as active
            }) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
    }
}
