import SwiftUI

struct DonateFoodView: View {
    @State private var foodTitle: String = ""
    @State private var description: String = ""
    @State private var showAddressPopup: Bool = false
    @State private var address: String = "Add Address"
    @State private var location: Location? = nil
    
    @State private var showImagePicker: Bool = false
    @State private var images: [UIImage] = []
    @State private var photoModels: [Photos] = []
    
    @State private var donationId: String = "donationId123"
    @State private var navigateToDashboard: Bool = false
    
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
                    
                    TextField("Best before", text: $foodTitle)
                        .font(.system(size: 16))
                        .padding(.vertical, 8)
                        .padding(.leading, 8)  // Padding for hint text
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    TextField("Price", text: $foodTitle)
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
                            savePhotos()
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
                    
                    NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) {
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
            .navigationBarHidden(true) // Hide the navigation bar
            .navigationBarBackButtonHidden(true) // Hide the back button
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
    
    private func savePhotos() {
        for (index, image) in images.enumerated() {
            let fileName = "photo_\(index).jpg"
            if let fileURL = Utils.saveImageToDocumentsDirectory(image: image, fileName: fileName) {
                let photoModel = Photos(donationId: donationId, photoPath: fileURL.path)
                photoModels.append(photoModel)
            }
        }
        print("Photos saved successfully.\(photoModels)")
        navigateToDashboard = true
    }
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
