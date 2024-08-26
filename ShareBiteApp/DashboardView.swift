import SwiftUI

struct DashboardView: View {
    @StateObject private var sessionManager = SessionManager.shared
    @State private var donationsCount: Int = 0
    @State private var collectionsCount: Int = 0
    private let donateFoodService = DonateFoodService()
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Join the Fight Against Hunger")
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 16) {
                                NavigationLink(destination: ShowRequestHistoryView()) {
                                        VStack {
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .padding(.top, 8)
                                            
                                            Text("\(donationsCount) Donations")
                                                .font(.system(size: 16))
                                                .padding(.top, 3)
                                                .padding(.bottom, 5)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .padding(.vertical)
                                    }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ShowRequestHistoryView()) {
                                    VStack {
                                        Image(systemName: "hand.raised.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding(.top, 8)
                                        
                                        Text("\(collectionsCount) Collections")
                                            .font(.system(size: 16))
                                            .padding(.top, 3)
                                            .padding(.bottom, 5)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.vertical)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()

                            Text("We encourage diversity in donations to ensure that we can meet the nutritional needs and dietary restrictions of everyone we serve.")
                                .padding(.horizontal, 12)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("Your Donation")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)

                            Divider().background(Color.gray)

                            Text("Your donation can help feed families in need. Every contribution, big or small, makes a significant impact. Together, we can fight hunger and ensure that no one goes without a meal.")
                                .padding(5)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)

                            NavigationLink(destination: DonateFoodView()) {
                                Text("Donate Food")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()

                            Text("News")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.bottom, 7)

                            Divider().background(Color.gray)

                            HStack {
                                Image("food")
                                    .resizable()
                                    .frame(width: 140, height: 90)
                                Image("food")
                                    .resizable()
                                    .frame(width: 140, height: 90)
                            }
                            .padding(4)
                        }
                        .padding()
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
//            .edgesIgnoringSafeArea(.bottom)
//            .navigationTitle("Dashboard")
//            .navigationBarHidden(true)
//            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadData)
        }
    }
    private func loadData() {
        guard let userId = sessionManager.getCurrentUser()?.id else { return }

           donateFoodService.fetchReport(userId: userId) { result in
               switch result {
               case .success(let report):
                   donationsCount = report.donations
                   collectionsCount = report.collections
               case .failure(let error):
                   print("Error fetching report: \(error.localizedDescription)")
               }
           }
       }
}

struct DashboardView_Preview: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
