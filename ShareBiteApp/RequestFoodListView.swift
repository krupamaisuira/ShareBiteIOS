import SwiftUI

struct RequestFoodListView: View {
    @State private var donatedFoods: [DonateFood] = []
    @State private var errorMessage: String?

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())] // Two columns
    @ObservedObject private var sessionManager = SessionManager.shared
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                HStack {
                    Text("Request Food")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationLink(destination: ShowRequestHistoryView()) {
                                           Text("Collections")
                                       }
                    .padding(.trailing, 5)
                }
                .padding(.top, 16)
                
                Divider()
                    .padding(.top, 10)
                
                Text("Browse available food donations and request items that you need. Help us reduce waste and feed those in need")
                    .font(.system(size: 14))
                    .padding(16)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(donatedFoods) { item in
                            CardView(donateFood: item)
                                .padding(16)
                                .background(Color.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
            }
            .onAppear {
                fetchDonatedFoods()
            }
        }
    }
    private func fetchDonatedFoods() {
            let donateFoodService = DonateFoodService()
            if let userId = sessionManager.getCurrentUser()?.id {
                donateFoodService.getAllRequestFoodList(userId: userId) { result in
                    switch result {
                    case .success(let foods):
                        self.donatedFoods = foods
    
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
    
                    }
                }
            } else {
                self.errorMessage = "donor is missing"
    
            }
        }
//    private func fetchDonatedFoods() {
//        let donateFoodService = DonateFoodService()
//        let userId = "EnKWlvpXBlR47CTjsZ5RTQfJhs52"
//        donateFoodService.getAllRequestFoodList(userId: userId) { result in
//            switch result {
//            case .success(let foods):
//                DispatchQueue.main.async {
//                    self.donatedFoods = foods
//                }
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
}

struct CardView: View {
    var donateFood: DonateFood

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let url = donateFood.uploadedImageUris?.first {
                AsyncImage(url: url)
                    .frame(width: 150, height: 120)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 120)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            HStack {
                Text(donateFood.title)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .truncationMode(.tail)

                NavigationLink(destination: RequestFoodDetailView(donationId: donateFood.donationId ?? "",showcancelled: 0)) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        // .padding()
                        //.background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top, 8)
            
            Text(donateFood.price > 0
                ? (donateFood.price.truncatingRemainder(dividingBy: 1) == 0
                    ? "Price: $\(Int(donateFood.price))"
                    : String(format: "Price: $%.2f", donateFood.price))
                : "Price: Free")
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
            
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(width: 150, height: 180)
        .contentShape(Rectangle()) // Ensures the whole view responds to taps
    }
}

#Preview {
    RequestFoodListView()
}
