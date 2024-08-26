import SwiftUI

struct DonatedFoodListView: View {
    @State private var donatedFoods: [DonateFood] = []
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var showAlert: Bool = false
    @State private var showConfirmationAlert: Bool = false
    @State private var deleteAction: (() -> Void)?

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Donations Food")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationLink(destination: FoodRequestedListView()) {
                                           Text("Food Requested")
                                       }
                    .padding(.trailing, 5)
                    
                    
                }
                .padding(.top, 16)
                
                Divider()
                    .padding(.top, 10)
                
                Text("Welcome to our food donation list page! Your generosity can make a big difference in the lives of those in need")
                    .font(.system(size: 14))
                    .padding(16)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(donatedFoods) { food in
                            DonatedFoodCardView(donateFood: food, onDelete: {
                                // Prepare for deletion
                                self.deleteAction = {
                                    deleteDonatedFood(food)
                                }
                                self.showConfirmationAlert = true
                            })
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text(successMessage ?? "Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this item?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteAction?()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    private func fetchDonatedFoods() {
            let donateFoodService = DonateFoodService()
            if let userId = sessionManager.getCurrentUser()?.id {
                donateFoodService.getAllDonatedFood(userId: userId) { result in
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
//        donateFoodService.getAllDonatedFood(userId: userId) { result in
//            switch result {
//            case .success(let foods):
//                self.donatedFoods = foods
//                
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//                self.showAlert = true
//            }
//        }
//    }
    
    private func deleteDonatedFood(_ food: DonateFood) {
        let donateFoodService = DonateFoodService()
        guard let donationId = food.donationId else {
            self.errorMessage = "Invalid donation ID"
            self.showAlert = true
            return
        }
        
        donateFoodService.deleteDonatedFood(donationId: donationId) { result in
            switch result {
            case .success:
                // Update the UI by removing the deleted food from the list
                if let index = self.donatedFoods.firstIndex(where: { $0.donationId == donationId }) {
                    self.donatedFoods.remove(at: index)
                }
                self.successMessage = "Food item successfully deleted."
                self.showAlert = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
}

struct DonatedFoodListView_Previews: PreviewProvider {
    static var previews: some View {
        DonatedFoodListView()
    }
}
