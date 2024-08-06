//
//  ChooseAddressView.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//


import SwiftUI
import GooglePlaces


struct ChooseAddressView: View {
    @Binding var show: Bool
    @Binding var selectedLocation: Location?
    //@Binding var selectedAddress: String // Binding to the selected address
    @State private var address: String = ""
    @State private var predictions: [GMSAutocompletePrediction] = []
    @State private var selectedPrediction: GMSAutocompletePrediction? // To hold the selected prediction
   
    @State private var placeDetails: GMSPlace?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        show.toggle()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }

                VStack {
                    Text("Choose Address")
                        .font(.title)
                        .padding()
                    TextField("Enter address", text: $address)
                        .onChange(of: address) { newValue in
                            self.performAutocomplete()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    List(predictions, id: \.placeID) { prediction in
                        Text(prediction.attributedFullText.string)
                            .onTapGesture {
                                self.selectedPrediction = prediction
                                self.address = prediction.attributedFullText.string
                                self.fetchPlaceDetails(for: prediction.placeID)
                            }
                    }
                    Button(action: {
                       
                        if let place = self.placeDetails {
                                                    let location = Location(
                                                        address: place.formattedAddress ?? "",
                                                        latitude: place.coordinate.latitude,
                                                        longitude: place.coordinate.longitude
                                                    )
                                                    self.selectedLocation = location
                                                    print("form location \(location.address)")
                                                }
                        show.toggle()
                    }) {
                        Text("Confirm address")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
    }

    private func performAutocomplete() {
        guard !address.isEmpty else {
            self.predictions = []
            return
        }

        let filter = GMSAutocompleteFilter()
        filter.type = .address

        let token = GMSAutocompleteSessionToken.init()

        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: address, filter: filter, sessionToken: token) { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                return
            }

            if let results = results {
                self.predictions = results
            } else {
                self.predictions = []
            }
        }
    }
    private func fetchPlaceDetails(for placeID: String) {
            let placeFields: GMSPlaceField = [.name, .formattedAddress, .coordinate]

            GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: placeFields, sessionToken: nil) { (place, error) in
                if let error = error {
                    print("Place details error: \(error.localizedDescription)")
                    return
                }

                if let place = place {
                    self.placeDetails = place
                }
            }
        }
}
