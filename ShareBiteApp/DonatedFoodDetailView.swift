import SwiftUI
import Combine

struct DonatedFoodDetailView: View {
    @State private var donatedFood: DonateFood?
    @State private var error: Error?
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    let donationId: String
    
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

                        
                        let foodStatusIndex = food.status
                                   if let foodStatus = FoodStatus.getByIndex(foodStatusIndex) {
                                       let statusColors = Utils.setStatusColors(for: foodStatus)
                                       
                                       Text(foodStatus.toString())
                                           .font(.system(size: 16))
                                           .padding(5)
                                           .background(statusColors.backgroundColor)
                                           .foregroundColor(statusColors.textColor)
                                           .cornerRadius(4)
                                           
                        }
                        
                       
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
                        .padding(.vertical, 16)

                    if let requestedBy = food.requestedBy,
                        food.status == FoodStatus.donated.rawValue ||
                        food.status == FoodStatus.requested.rawValue {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Requested By")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.bottom, 5)
                            
                            Text("User Name: \(requestedBy.requestedUserDetail?.username ?? "N/A")")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Text("Email: \(requestedBy.requestedUserDetail?.email ?? "N/A")")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Text("Phone: \(requestedBy.requestedUserDetail?.mobilenumber ?? "N/A")")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 16) // Added padding
                        if food.status == FoodStatus.requested.rawValue {
                            HStack(spacing: 8) {
                                Button(action: {
                                    handleDonateAction()
                                }) {
                                    Text("Donate")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(5)
                                }
                                
                                Button(action: {
                                    handleCancelRequest()
                                }) {
                                    Text("Cancel Request")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }
                            }
                            
                            .padding(.top, 10)
                            .padding(.horizontal, 16)
                        }
                    }
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
                    .padding(.horizontal, 16) // Added padding
                    .padding(.top, 5)
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
        .onAppear {
            fetchDonationDetail()
        }
        .alert(isPresented: $showingAlert) {
                   Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
                    updateFoodStatus()
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    private func updateFoodStatus() {
        
        if let bestBeforeDate = donatedFood?.bestBefore {
            print("best before data \(bestBeforeDate)")
            if Utils.isFoodExpired(bestBeforeDateStr: bestBeforeDate) == 0 {
                donatedFood?.status = FoodStatus.expired.rawValue
            }
        }
    }
    private func handleDonateAction() {
           guard let donationId = donatedFood?.donationId else {
               print("Donation ID not found.")
               return
           }

           let donateFoodService = DonateFoodService()
           let newStatus = FoodStatus.donated.rawValue

           donateFoodService.updateFoodStatus(uid: donationId, status: newStatus) { result in
               DispatchQueue.main.async {
                   switch result {
                   case .success:
                       donatedFood?.status = newStatus
                       donatedFood?.requestedBy = nil
                       showAlert(title: "Food Donated", message: "Food has been successfully donated.")
                   case .failure(let error):
                       showAlert(title: "Error", message: "Failed to update food status: \(error.localizedDescription)")
                   }
               }
           }
       }
    private func handleCancelRequest() {
        guard let donationId = donatedFood?.donationId else {
            print("Donation ID not found.")
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
        let sessionManager = SessionManager.shared
        let requestFoodService = RequestFoodService()
        let donateFoodService = DonateFoodService()
        let newStatus = FoodStatus.available.rawValue

        print("cancel id : \(cancelid)")
        print("donation id : \(donationId)")
        if let userId = sessionManager.getCurrentUser()?.id {
            requestFoodService.requestFoodCancel(uid: cancelid, cancelBy: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            // If cancellation is successful, update the food status
                            donateFoodService.updateFoodStatus(uid: donationId, status: newStatus) { result in
                                switch result {
                                case .success:
                                    //donatedFood?.requestedBy = nil
                                    donatedFood?.status = newStatus
                                   
                                    self.showAlert(title: "Request Canceled", message: "This donation is now available for other users.")
                                case .failure(let error):
                                    self.showAlert(title: "Error", message: "Failed to update food status: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            self.showAlert(title: "Error", message: "Failed to cancel request: \(error.localizedDescription)")
                        }
                    }
                }
        } else {
            
            print("User ID is nil.please try after sometime")
        }
           
    }

    
       private func showAlert(title: String, message: String) {
           alertTitle = title
           alertMessage = message
           showingAlert = true
       }

}

struct DonatedFoodDetailView_Previews: PreviewProvider {
        static var previews: some View {
            DonatedFoodDetailView(donationId: "-O54tdChb-RRsMmR-LVn") // Provide a sample ID for preview
        }
    }
