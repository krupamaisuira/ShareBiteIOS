//
//  RequestFoodDetailView.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import SwiftUI

struct RequestFoodDetailView: View {
    var body: some View {
        VStack{
                    
                    Image("veg")
                        .resizable()
                        .frame(width: 390, height: 200).padding(-7)
                    
                    Divider().background(Color.gray)
                    
                            HStack(alignment: .top) {
                                Text("Fresh Organic Apples        ")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                    
                                Text("Price : free")
                                    .font(.system(size:20))
                                
                            }.padding(.bottom, 5)
                    
                        Text("Best before : today")
                        .font(.system(size:20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading).padding(.bottom,5)
                
                    Text("Available")
                    .font(.system(size:22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .fontWeight(.bold)
                    .padding(.bottom,10)
                    
                    Divider().background(Color.gray).padding(.bottom,5)
                    
                            Text("A pack of fresh, organic apples perfect for snacking or baking. These apples are locally sourced from a certified organic farm")
                        .font(.system(size: 18)).padding(.bottom,5)
                    
                    Text("Pickup Address")
                    .font(.system(size:22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .fontWeight(.bold)
                    .padding(.bottom,5)
                    
                    Divider().background(Color.gray).padding(.bottom,5)
                    
                    HStack{
                        
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
        .foregroundColor(.blue)
                            .padding(7)
                        Text("Montreal Quebec H3N 2N6             ")
                            .font(.system(size:20))
                            .fontWeight(.bold)
                    }
                    
                    Divider().background(Color.gray).padding(.bottom,12)
                    
                    NavigationLink(destination: request_food()) {
                        Text("Request")
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

#Preview {
    RequestFoodDetailView()
}
