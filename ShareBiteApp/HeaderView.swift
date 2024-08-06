import SwiftUI

struct HeaderView: View {
   
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 45, height: 45)
            Text("ShareBite")
                .fontWeight(.bold)
                .font(.system(size: 20))
        
            
        }
        
    }
}
