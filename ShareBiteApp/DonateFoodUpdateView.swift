    import SwiftUI

    struct DonateFoodUpdateView: View {
        @State private var foodTitle: String = ""
        @State private var description: String = ""
        @State private var bestBefore: String = ""
        @State private var price: String = ""
        @State private var showAddressPopup: Bool = false
        @State private var address: String = "Add Address"
        @State private var location: Location? = nil
        
        @State private var showImagePicker: Bool = false
        @State private var images: [UIImage] = []
        @State private var newimages: [UIImage] = []
        @State private var imageURLs: [String] = []
        
        let donationId: String
        @State private var showAlert: Bool = false
        @State private var alertMessage: String = ""
        @State private var selectedDate = Date()
        @State private var showDatePicker = false
        @State private var donatedFood: DonateFood?
        @ObservedObject private var sessionManager = SessionManager.shared
        @Environment(\.presentationMode) var presentationMode
        @State private var removedImageURLs: [String] = []
        var body: some View {
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
                            .padding(.leading, 8)
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
                                    .disabled(true)
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
                                    self.bestBefore = formatter.string(from: selectedDate)
                                    self.showDatePicker = false
                                }
                                .padding()
                            }
                        }
                        
                        TextField("Price", text: $price)
                            .font(.system(size: 16))
                            .padding(.vertical, 8)
                            .padding(.leading, 8)
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
                                Text("Update Donated Food")
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
                                newimages.append(image)
                                
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
                    fetchDonationDetail()
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Validation Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        
        private func isRunningInPreview() -> Bool {
            return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }
        
        private func removeImage(at index: Int) {
            // Ensure the index is within the bounds of the images array
            guard index >= 0, index < images.count else {
                print("Index out of bounds: images.count=\(images.count), index=\(index)")
                return
            }
            
            // Handle cases where imageURLs might not be in sync
            if index < imageURLs.count {
                // Safely retrieve and remove the image URL
                let removedImageURL = imageURLs[index]
                
                // Remove the image and URL from the arrays
                images.remove(at: index)
                imageURLs.remove(at: index)
                
                // Add the removed URL to the removedImageURLs array
                removedImageURLs.append(removedImageURL)
            } else {
                // When there's no corresponding URL, just remove the image
                let removedImage = images[index]
                images.remove(at: index)
                if let newIndex = newimages.firstIndex(of: removedImage) {
                        newimages.remove(at: newIndex)
                    }
                
            }
           
        }



        
        private func showAlert(message: String) {
            alertMessage = message
            showAlert = true
        }
        private func validateAndSave() {
           
            if images.isEmpty {
                showAlert(message: "Please add at least one photo.")
                return
            }
            
            print("address : \(location?.address)")
            guard let unwrappedLocation = location else {
                showAlert(message: "Please select an address.")
                return
            }
            
          
            if foodTitle.isEmpty {
                showAlert(message: "Please enter a title for the food.")
            } else if description.isEmpty {
                showAlert(message: "Please enter a description for the food.")
            } else if bestBefore.isEmpty {
                showAlert(message: "Please enter the best before.")
            } else if !price.isEmpty, Double(price) == nil {
                showAlert(message: "Please enter a valid price.")
            } else {
                print("un wrapped address : \(unwrappedLocation.address)")
                let getLocation = Location(
                    locationId: donatedFood?.location?.locationId ?? "",
                    donationId: donationId,
                    address: unwrappedLocation.address,
                    latitude: unwrappedLocation.latitude,
                    longitude: unwrappedLocation.longitude
                )
                location = getLocation
                saveDonateFood()
            }
        }

        private func saveDonateFood() {
           
            let donatedFoodPriceString = donatedFood?.price != nil ? String(format: "%.2f", donatedFood!.price) : ""

            let shouldUpdateFood = foodTitle != donatedFood?.title ||
                                            description != donatedFood?.description ||
                                            bestBefore != donatedFood?.bestBefore ||
                                            price != donatedFoodPriceString
                    
            let shouldUpdateLocation = location?.address != donatedFood?.location?.address ||
                                               location?.latitude != donatedFood?.location?.latitude ||
                                               location?.longitude != donatedFood?.location?.longitude
            // update food
            if shouldUpdateFood {
                let priceDouble = Double(price) ?? 0.0
                // Create a DonateFood object
                let food = DonateFood(
                    donationId: donationId, title: foodTitle, description: description, bestBefore: bestBefore, price: priceDouble
                    
                )
                
                // Create a service instance
                let donateFoodService = DonateFoodService()
                
                // Use the service to donate food
                donateFoodService.updateDonatedFood(food : food) { result in
                    switch result {
                    case .success:
                        // Navigate to Dashboard on success
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss()
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
            // update location
            if shouldUpdateLocation
                
            { print("in location update address : \(location?.address)")
                if let locationToUpdate = location {
                                let locationService = LocationService()
                                locationService.updateLocation(model: locationToUpdate) { result in
                                    switch result {
                                    case .success:
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    case .failure(let error):
                                        let errorMessage = error.localizedDescription
                                        DispatchQueue.main.async {
                                            self.showAlert(message: errorMessage)
                                        }
                                    }
                                }
                            } else {
                                self.showAlert(message: "Location data is missing for update.")
                            }
            }
          
            
            if !removedImageURLs.isEmpty || !newimages.isEmpty {
               let existingImageURLs = donatedFood?.uploadedImageUris?.map { $0.absoluteString } ?? []

                let photoservice = PhotoService()
                photoservice.updateImages(donationId: donationId, newImages: newimages, existingImageUrls: existingImageURLs, imagesToRemove: removedImageURLs) { result in
                                    switch result {
                                    case .success:
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            self.showAlert(message: error.localizedDescription)
                                        }
                                    }
                                }
                            }
    //        if shouldUpdatePhotos {
    //                            self.updateImages(donationId: donationId, newImages: newImages, existingImageUrls: existingImageUrls, imagesToRemove: imagesToRemove) { result in
    //                                switch result {
    //                                case .success:
    //                                    DispatchQueue.main.async {
    //                                        self.presentationMode.wrappedValue.dismiss()
    //                                    }
    //                                case .failure(let error):
    //                                    self.showAlert(message: error.localizedDescription)
    //                                }
    //                            }
    //                        } else {
    //                            DispatchQueue.main.async {
    //                                self.presentationMode.wrappedValue.dismiss()
    //                            }
    //                        }
            self.presentationMode.wrappedValue.dismiss()

        }
        private func fetchDonationDetail() {
            
            let donateFoodService = DonateFoodService()
            donateFoodService.getDonationDetail(uid: donationId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let food):
                        donatedFood = food
                        foodTitle = food.title
                        description = food.description
                        bestBefore = food.bestBefore
                        price = food.price > 0 ? "\(food.price)" : ""
                        location = food.location
                        
                        if let imageUrls = food.uploadedImageUris, !imageUrls.isEmpty {
                                loadImages(from: imageUrls)
                                
                        }
                    case .failure(let error):
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
        private func loadImages(from urls: [URL]) {
            let dispatchGroup = DispatchGroup()
            
            var loadedImages: [UIImage] = []
            var loadedImageURLs: [String] = []
            for url in urls {
                dispatchGroup.enter()
                
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        loadedImages.append(image)
                        loadedImageURLs.append(url.absoluteString)
                    }
                    dispatchGroup.leave()
                }.resume()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.images = loadedImages
                self.imageURLs = loadedImageURLs
            }
        }


    }

    struct DonateFoodUpdateView_Preview: PreviewProvider {
        static var previews: some View {
            DonateFoodUpdateView(donationId: "-O5ECbbXKveNA08lxIR4")
        }
    }

