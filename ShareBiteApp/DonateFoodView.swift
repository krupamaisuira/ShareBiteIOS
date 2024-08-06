import SwiftUI

struct DonateFoodView: View {
    @State private var foodTitle: String = ""
    @State private var description: String = ""
    @State private var showAddressPopup: Bool = false
    @State private var address: String = "Add Address" // Default value
    @State private var location: Location? = nil
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    Text("Join the Fight Against Hunger")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .padding(.leading, 5)
                        .foregroundColor(.black)
                    Text("Photo(s)")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.top, 3)
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                            .padding()
                    }
                    Text("3 photos max")
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .foregroundColor(Color.gray)
                    Divider().background(Color.gray).padding(2)
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showAddressPopup.toggle()
                            }
                        Text(location?.address ?? "Add Address")
                                                    .font(.system(size: 16))
                                                    .fontWeight(.bold)
                    }
                    Divider().background(Color.gray).padding(2)
                    Text("Title")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    TextField("E.g. sandwich, cakes, vegetables", text: $foodTitle)
                        .font(.system(size: 20))
                        .frame(width: 300)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 35)
                        )
                    Divider().background(Color.gray).padding(4)
                    Text("Description")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    VStack {
                        TextEditor(text: $description)
                            .padding()
                            .background(Color.white)
                            .border(Color.gray, width: 1)
                            .frame(width: 350, height: 100)
                            .cornerRadius(8)
                    }.padding(7)
                    TextField("Best before", text: $foodTitle)
                        .font(.system(size: 16))
                        .padding(.bottom, 25)
                        .frame(width: 350)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 25)
                        )
                    TextField("Price", text: $foodTitle)
                        .font(.system(size: 16))
                        .padding(.bottom, 20)
                        .frame(width: 350)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 20)
                        )
                    Text("Price is optional")
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .foregroundColor(Color.gray)
                    NavigationLink(destination: DashboardView()) {
                        Text("Donate")
                            .frame(maxWidth: 140, maxHeight: 10)
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
        .overlay(
            Group {
                if showAddressPopup {
                    ChooseAddressView(show: $showAddressPopup, selectedLocation: $location)
                }
            }
        )
        .onAppear {
            location = nil
            // Optionally reset the address here if needed
        }
    }
}

struct DonateFoodView_Preview: PreviewProvider {
    static var previews: some View {
        DonateFoodView()
    }
}
