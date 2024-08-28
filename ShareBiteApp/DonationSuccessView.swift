import SwiftUI

struct DonationSuccessView: View {
    @State private var isShareSheetPresented = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                   
                
                Text("Only a few moments left!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text("We're reviewing your ad and it will be available as soon as possible.")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                Text("Share it with your friends")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Your ad may interest your friends or loved ones.\nShare it!")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 10) {
                                   Image(systemName: "square.and.arrow.up")
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 30, height: 30)
                                   
                                   Button(action: {
                                       isShareSheetPresented.toggle()
                                   }) {
                                       Text("SHARING OPTIONS")
                                           .foregroundColor(.black)
                                           .underline()
                                   }
                                   .buttonStyle(PlainButtonStyle())
                                   .sheet(isPresented: $isShareSheetPresented) {
                                       ShareSheet(activityItems: getShareItems(), isPresented: $isShareSheetPresented)
                                   }
                               }
                
                NavigationLink(destination: DonateFoodView()) {
                    Text("Post another food")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 44)
                        .background(Color.blue) // Or any color of your choice
                        .cornerRadius(8)
                }
                .padding(.top, 30)
            }
            .padding(16)
            .background(Color.white)
            .navigationBarHidden(true)               
            .navigationBarBackButtonHidden(true)
        }
    }
    private func getShareItems() -> [Any] {
           let textItems = [
               "Join the Fight Against Hunger",
               "Our amazing donors have just uploaded nutritious food items to our app!",
               "Every contribution counts towards feeding those in need and building a stronger community. Join us in making a positive impact today!",
               "#FoodDonation #CommunitySupport #ShareBiteApp"
           ]
           
           guard let image = UIImage(named: "logo") else { return textItems }
           
           return textItems + [image]
       }
}



struct DonationSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        DonationSuccessView()
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.modalPresentationStyle = .formSheet
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            isPresented = false
        }
        uiViewController.present(activityViewController, animated: true, completion: nil)
    }
}
