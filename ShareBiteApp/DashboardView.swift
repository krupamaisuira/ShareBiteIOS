import SwiftUI

struct DashboardView: View {
    @StateObject private var sessionManager = SessionManager.shared

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Join the Fight Against Hunger")
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            HStack {
                                VStack {
                                    Text("0")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text("Donations")
                                        .fontWeight(.bold)
                                    Image(systemName: "heart")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 4)
                                        .padding(7)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))

                                Spacer()

                                VStack {
                                    Text("0")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text("Collections")
                                        .fontWeight(.bold)
                                    Image(systemName: "cart")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 4)
                                        .padding(7)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                            }
                            .padding()
                            .cornerRadius(10)

                            Text("We encourage diversity in donations to ensure that we can meet the nutritional needs and dietary restrictions of everyone we serve.")
                                .padding(12)
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
                                    .frame(maxWidth: .infinity, maxHeight: 10)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                            .cornerRadius(10)

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
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Dashboard")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct DashboardView_Preview: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
