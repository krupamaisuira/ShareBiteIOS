//
//  RequestFoodDetailView.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import SwiftUI


struct RequestFoodDetailView: View {
    @State private var donatedFood: DonateFood?
    @State private var error: Error?
    @State private var isLoading = false
    @State private var showRequestButton = true
    @State private var showCancelButton = false
    
    let donationId: String
    let showcancelled: Int
    @ObservedObject private var sessionManager = SessionManager.shared
    let requestFoodService = RequestFoodService()
    let donateFoodService = DonateFoodService()
    @State private var navigateToSuccessView = false
    @State private var navigateToRequestListView = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Join the Fight Against Hunger")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 5)
                    .padding(.horizontal, 16) // Added padding

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let food = donatedFood {
                    if let url = food.uploadedImageUris?.first {
                        AsyncImage(url: url)
                            .frame(width: 400, height: 250)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 250)
                    }

                    Divider()
                        .padding(.vertical, 16)

                    HStack {
                        Text(food.title)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16) // Added padding

                    Text("Best before: \(food.bestBefore)")
                        .font(.system(size: 16))
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16) // Added padding

                    Text(food.price > 0
                        ? (food.price.truncatingRemainder(dividingBy: 1) == 0
                            ? "Price: $\(Int(food.price))"
                            : String(format: "Price: $%.2f", food.price))
                        : "Price: Free")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.bottom, 5)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 16)
                    Text(food.description)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16) // Added padding
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Photos")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        Divider()
                            .padding(.bottom, 5)

                        if let imageUris = food.uploadedImageUris, !imageUris.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(imageUris, id: \.self) { url in
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                EmptyView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 140, height: 100)
                                                    .clipped()
                                            case .failure:
                                                Image(systemName: "photo.fill")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 140, height: 100)
                                                    .background(Color.gray.opacity(0.2))
                                                    .clipped()
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.horizontal, 16)
                            }
                            .frame(height: 120) // Adjust height as needed
                        }
                    }

                    Text("Pickup Address")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    Divider()
                        .padding(.bottom, 5)

                    HStack {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 8)

                        Text(food.location?.address ?? "Address not available")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 8) {
                                            if showRequestButton {
                                                Button(action: {
                                                    requestFood()
                                                }) {
                                                    Text("Request")
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .background(Color.green)
                                                        .cornerRadius(5)
                                                }
                                            }
                                            
                                            if showCancelButton {
                                                Button(action: {
                                                    cancelFoodRequest()
                                                }) {
                                                    Text("Cancel Request")
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .background(Color.red)
                                                        .cornerRadius(5)
                                                }
                                            }
                                        }
                    .padding(.horizontal, 16) // Added padding
                    .padding(.top, 5)
                    NavigationLink(destination: request_food(location: donatedFood?.location?.address ?? ""), isActive: $navigateToSuccessView) {
                                    EmptyView()
                                }.hidden()
                                
                                // NavigationLink to request list view
                                NavigationLink(destination: RequestFoodListView(), isActive: $navigateToRequestListView) {
                                    EmptyView()
                                }.hidden()

                } else if let error = error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                        .padding(.horizontal, 16) // Added padding
                }
            }
            .padding(5)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 16) // Added padding
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchDonationDetail()
        }
    }

    private func fetchDonationDetail() {
        isLoading = true
        let donateFoodService = DonateFoodService()
        donateFoodService.getDonationDetail(uid: donationId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let food):
                    donatedFood = food
                  
                    updateButtonVisibility(food)
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    private func updateButtonVisibility(_ food: DonateFood) {
            if showcancelled == 1 {
               
                if food.status == FoodStatus.requested.rawValue {
                    showCancelButton = true
                    showRequestButton = false
                } else if food.status == FoodStatus.available.rawValue{
                    showRequestButton = true
                    showCancelButton = false
                }
            } else {
                showCancelButton = false
                showRequestButton = true
            }
        }
        
    private func requestFood() {
           isLoading = true
        let request = RequestFood(requestforId: donationId, requestedBy: sessionManager.getCurrentUser()?.id, cancelBy: nil, cancelon: nil)
           
        requestFoodService.requestFood(model: request) { result in
               DispatchQueue.main.async {
                   isLoading = false
                   switch result {
                   case .success:
                       donateFoodService.updateFoodStatus(uid: donationId, status: FoodStatus.requested.rawValue) { updateResult in
                           switch updateResult {
                           case .success:
                               navigateToSuccessView = true
                               // Navigate to success view
//                                   if let location = donatedFood?.location?.address {
//                                       let historyView = request_food(location : location) // Your SwiftUI view
//                                                              let hostingController = UIHostingController(rootView: historyView)
//                                                              if let window = UIApplication.shared.windows.first {
//                                                                  window.rootViewController?.present(hostingController, animated: true, completion: nil)
//                                                              }
//                                   }
                           case .failure(let error):
                               self.error = error
                           }
                       }
                   case .failure(let error):
                       self.error = error
                   }
               }
           }
       }

       private func cancelFoodRequest() {
           isLoading = true
               guard let userId = sessionManager.getCurrentUser()?.id else {
                 
                   self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
                   isLoading = false
                   return
               }
           let foodRequestId: String?
           if let requestedBy = donatedFood?.requestedBy {
                               foodRequestId = requestedBy.requestId
                           } else {
                               foodRequestId = nil // Or set a default value if needed
                           }
           
           guard let cancelid = foodRequestId else {
             
               self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something wrong please try again."])
               isLoading = false
               return
           }
           requestFoodService.requestFoodCancel(uid: cancelid, cancelBy: userId) { result in
               DispatchQueue.main.async {
                   isLoading = false
                   switch result {
                   case .success:
                       donateFoodService.updateFoodStatus(uid: donationId, status: FoodStatus.available.rawValue) { updateResult in
                           switch updateResult {
                           case .success:
                               navigateToRequestListView = true
//                               let historyView = RequestFoodListView() // Your SwiftUI view
//                                                      let hostingController = UIHostingController(rootView: historyView)
//                                                      if let window = UIApplication.shared.windows.first {
//                                                          window.rootViewController?.present(hostingController, animated: true, completion: nil)
//                                                      }
                           case .failure(let error):
                               self.error = error
                           }
                       }
                   case .failure(let error):
                       self.error = error
                   }
               }
           }
       }
}


struct RequestFoodDetailView_Previews: PreviewProvider {
        static var previews: some View {
            RequestFoodDetailView(donationId: "-O54tdChb-RRsMmR-LVn",showcancelled: 0) // Provide a sample ID for preview
        }
    }
