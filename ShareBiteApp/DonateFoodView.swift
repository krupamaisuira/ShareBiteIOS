import SwiftUI

struct DonateFoodView: View {
    @State private var foodTitle: String = ""
    @State private var description: String = ""
    @State private var bestBefore : String = ""
    @State private var price : String = ""
    @State private var showAddressPopup: Bool = false
    @State private var address: String = "Add Address"
    @State private var location: Location? = nil
    
    @State private var showImagePicker: Bool = false
    @State private var images: [UIImage] = []
    @State private var photoModels: [Photos] = []
    
    //@State private var donationId: String = "donationId123"
    @State private var navigateToSuccess: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @ObservedObject private var sessionManager = SessionManager.shared
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Join the Fight Against Hunger")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Photo(s)")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            VStack {
                                Spacer(minLength: 16)
                                
                                HStack {
                                    ForEach(images.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: images[index])
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            Button(action: {
                                                removeImage(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                    
                                    if images.count < 3 {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.orange)
                                            .padding()
                                            .onTapGesture {
                                                if !isRunningInPreview() {
                                                    showImagePicker.toggle()
                                                }
                                            }
                                    }
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Text("3 photos max")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading)
                        }
                        
                        Divider().background(Color.gray).padding(.horizontal, 5)
                        
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    showAddressPopup.toggle()
                                }
                            
                            Text(location?.address ?? "Add Address")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        
                        Divider().background(Color.gray).padding(.horizontal, 5)
                        
                        Text("Title")
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                            .padding(.leading)
                        
                        TextField("E.g. sandwich, cakes, vegetables", text: $foodTitle)
                            .font(.system(size: 16))
                            .padding(.vertical, 8)
                            .padding(.leading, 8)  // Padding for hint text
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        Divider().background(Color.gray).padding(.horizontal, 5)
                        
                        Text("Description")
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                            .padding(.leading)
                        
                        TextEditor(text: $description)
                            .padding()
                            .background(Color.white)
                            .border(Color.gray, width: 1)
                            .frame(width: 350, height: 100)
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            HStack {
                                TextField("Best before", text: $bestBefore)
                                    .font(.system(size: 16))
                                    .padding(.vertical, 8)
                                    .padding(.leading, 8)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .disabled(true)  // Prevent direct editing
                                    .padding(.horizontal)
                            }
                        }
                        .sheet(isPresented: $showDatePicker) {
                            VStack {
                                DatePicker("Select Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .padding()
                                
                                Button("Done") {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                                    //  formatter.dateFormat = "MMM d, yyyy h:mm a"
                                    //                                                    formatter.dateStyle = .medium
                                    //                                                    formatter.timeStyle = .short
                                    self.bestBefore = formatter.string(from: selectedDate)
                                    self.showDatePicker = false
                                }
                                .padding()
                            }
                        }
                        
                        TextField("Price", text: $price)
                            .font(.system(size: 16))
                            .padding(.vertical, 8)
                            .padding(.leading, 8)  // Padding for hint text
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        Text("Price is optional")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                validateAndSave()
                            }) {
                                Text("Donate")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.headline)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            Spacer()
                        }
                        
                        NavigationLink(destination: DonationSuccessView(), isActive: $navigateToSuccess) {
                            EmptyView()
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showImagePicker) {
                    if isRunningInPreview() {
                        MockImagePicker()
                    } else {
                        ImagePicker { image in
                            if images.count < 3 {
                                images.append(image)
                            }
                            showImagePicker = false
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
                }
                
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Validation Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarHidden(true)
           .navigationBarBackButtonHidden(true)
        }
    }
    
    private func isRunningInPreview() -> Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    private func removeImage(at index: Int) {
        if index < images.count {
            images.remove(at: index)
        }
    }
    private func showAlert(message: String) {
            alertMessage = message
            showAlert = true
    }
    private func validateAndSave() {
            if images.isEmpty {
                showAlert(message: "Please add at least one photo.")
            } else if location == nil {
                showAlert(message: "Please select an address.")
            } else if foodTitle.isEmpty {
                showAlert(message: "Please enter a title for the food.")
            } else if description.isEmpty {
                showAlert(message: "Please enter a description for the food.")
            } else if bestBefore.isEmpty {
                showAlert(message: "Please enter the best before.")
            } else if !price.isEmpty && Double(price) == nil {
                showAlert(message: "Please enter a valid price.")
            } else {
                saveDonateFood()
            }
    }
    private func saveDonateFood() {
       
       
        let donatedBy = sessionManager.getCurrentUser()?.id ?? "Anonymous"
        let priceDouble = Double(price) ?? 0.0
        // Create a DonateFood object
        let food = DonateFood(
            donatedBy: donatedBy,
            title: foodTitle,
            description: description,
            bestBefore: bestBefore,
            price: priceDouble,
            location: location!,
            imageUris: [],
            status: FoodStatus.available.rawValue,
            saveImage: images
        )
        
        // Create a service instance
        let donateFoodService = DonateFoodService()
        
        // Use the service to donate food
        donateFoodService.donateFood(food) { result in
            switch result {
            case .success:
                // Navigate to Dashboard on success
                DispatchQueue.main.async {
                    self.navigateToSuccess = true
                }
            case .failure(let error):
                // Convert the error to a string and show an alert
                let errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    self.showAlert(message: errorMessage)
                }
            }
        }

    }


//    private func savePhotos() {
//        for (index, image) in images.enumerated() {
//            let fileName = "photo_\(index).jpg"
//            if let fileURL = Utils.saveImageToDocumentsDirectory(image: image, fileName: fileName) {
//                let photoModel = Photos(donationId: donationId, imagePath: fileURL.path, order : index)
//                photoModels.append(photoModel)
//            }
//        }
//        print("Photos saved successfully.\(photoModels)")
//        navigateToDashboard = true
//    }
}

struct DonateFoodView_Preview: PreviewProvider {
    static var previews: some View {
        DonateFoodView()
    }
}

struct MockImagePicker: View {
    var body: some View {
        Text("Mock Image Picker")
    }
}
