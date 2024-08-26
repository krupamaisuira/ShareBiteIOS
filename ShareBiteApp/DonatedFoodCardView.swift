    import SwiftUI

    struct DonatedFoodCardView: View {
        var donateFood: DonateFood
        var onDelete: () -> Void
        init(donateFood: DonateFood, onDelete: @escaping () -> Void) {
                self.donateFood = donateFood
                self.onDelete = onDelete
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
                    NavigationLink(destination: DonatedFoodDetailView(donationId: donateFood.donationId ?? "")) {
                        Text(donateFood.title)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    
                    HStack(spacing: 0){
                        NavigationLink(destination: DonateFoodUpdateView(donationId: donateFood.donationId ?? "")) {
                                                Image(systemName: "pencil")
                                                    .padding(2)
                                            }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            onDelete() 
                        }) {
                            Image(systemName: "trash")
                               // .padding(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 8)
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
            .frame(width: 150, height: 180)
            .contentShape(Rectangle())
        }
        private func updateFoodStatus() {
               if Utils.isFoodExpired(bestBeforeDateStr: donateFood.bestBefore) == 0 {
                   donateFood.status = FoodStatus.expired.rawValue
               }
           }
    }
