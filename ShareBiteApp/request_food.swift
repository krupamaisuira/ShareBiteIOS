import SwiftUI

struct request_food: View {
    let location: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Your request is confirmed!")
                                   .font(.system(size: 25))
                                   .fontWeight(.bold)
                                   .padding(.bottom, 2)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.center)
                                   .frame(maxWidth: .infinity, alignment: .center)
                                   .padding(.horizontal)
                
                Text("We have received your food request. A confirmation code has been sent to your phone via SMS")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Instructions")
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Divider().background(Color.gray)
                    .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Text("=>")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text("Head to the pickup location specified in the food item details")
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true) // Allow text to wrap
                }
                .padding(.bottom, 8)
                .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Text("=>")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text("Show the confirmation code you received via SMS to the staff at the pickup location")
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 8)
                .padding(.horizontal)
                
                Text("Pickup Location : \(location)")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Text("=> ")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text("Collect your requested food items")
                        .font(.system(size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing, 50)
                }
                .padding(.bottom, 8)
                .padding(.horizontal)
                
                Text("Both you and the donor will receive a notification with the same confirmation code to ensure a smooth handover.")
                    .font(.system(size: 18))
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                Divider().background(Color.gray)
                    .padding(.horizontal)
                
                Text("If you have any questions or issues, please contact us")
                    .font(.system(size: 18))
                    .padding()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.black)
                        Text("+1 454 111 1111")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.black)
                        Text("sharebite@gmail.com")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                HStack {
                                    Spacer()
                                    NavigationLink(destination: DashboardView()) {
                                        Text("Home")
                                            .frame(maxWidth: 140, maxHeight: 10)
                                            .padding()
                                            .background(Color.cyan)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                    Spacer()
                                }
            }
        }
        .navigationBarHidden(true)               
               .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    request_food(location: "7444 ave")
//}
