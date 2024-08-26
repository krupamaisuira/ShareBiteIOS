//
//  ShowRequestHistoryView.swift
//  ShareBiteApp
//
//  Created by Vivek Patel on 2024-08-25.
//

import SwiftUI

struct ShowRequestHistoryView: View {
    @State private var donatedFoods: [DonateFood] = []
    @State private var errorMessage: String?

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())] // Two columns
    @ObservedObject private var sessionManager = SessionManager.shared
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Your Collections")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.top, 16)
                
                Divider()
                    .padding(.top, 10)
                
                Text("Thank you for your support! Please review the requested food donations below and cancel any items no longer needed. This helps us minimize waste and ensure the food reaches those in need.")
                    .font(.system(size: 14))
                    .padding(16)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(donatedFoods) { item in
                            HistoryCardView(donateFood: item)
                        }
                    }
                    .padding()
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
            donateFoodService.fetchRequestedDonationList(userId: userId) { foods, errorMessage in
                if let errorMessage = errorMessage {
                    self.errorMessage = errorMessage
                } else if let foods = foods {
                    self.donatedFoods = foods
                    print("donated food in history \(foods.count)")
                } else {
                    self.errorMessage = "Unexpected error occurred."
                }
            }
        } else {
            self.errorMessage = "Donor is missing"
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

struct HistoryCardView: View {
    var donateFood: DonateFood
    init(donateFood: DonateFood) {
            self.donateFood = donateFood
            updateFoodStatus()
        }
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
            let foodStatusIndex = donateFood.status
                       if let foodStatus = FoodStatus.getByIndex(foodStatusIndex) {
                           let statusColors = Utils.setStatusColors(for: foodStatus)
                           
                           Text(foodStatus.toString())
                               .font(.system(size: 14))
                               .padding(.horizontal, 4)
                               .background(statusColors.backgroundColor)
                               .foregroundColor(statusColors.textColor)
                               .cornerRadius(4)
                               .frame(width: 150, alignment: .leading)
            }
            HStack {
               
                    Text(donateFood.title)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
               
                
                NavigationLink(destination: RequestFoodDetailView(donationId: donateFood.donationId ?? "" ,showcancelled : 1)) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        // .padding()
                        //.background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: request_food(location: donateFood.location?.address ?? "")) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        // .padding()
                        //.background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 8)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(width: 150, height: 180)
        .contentShape(Rectangle()) // Ensures the whole view responds to taps
    }
    private func updateFoodStatus() {
           if Utils.isFoodExpired(bestBeforeDateStr: donateFood.bestBefore) == 0 {
               donateFood.status = FoodStatus.expired.rawValue
           }
       }
}




#Preview {
    ShowRequestHistoryView()
}
