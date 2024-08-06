//
//  RequestFoodListView.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import SwiftUI

struct RequestFoodListView: View {
    var body: some View {
        Text("Request Food")
                           .font(.system(size: 25))
                           .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                           .foregroundColor(.black)
                           
               
               Divider().background(Color.gray).padding(.bottom,5)
               
           
               Text("Browse available food donations and request items that you need. Help us reduce waste and feed those in need")
                       .font(.system(size: 20))
                       .padding()
               
               HStack {
                   
                   VStack{
                       
                       Image(systemName: "camera.on.rectangle")
                           .resizable()
                           .frame(width: 140, height: 90).padding()
                       HStack{
                           
                           Text("Cake           ")
                               .fontWeight(.bold)
                           Image(systemName: "cart.badge.plus")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 24, height: 24)
                           
                       }
                       
                   }
                   
                 
                   VStack{
                       
                       Image(systemName: "camera.on.rectangle")
                           .resizable()
                           .frame(width: 140, height: 90).padding()
                       HStack{
                           
                           Text("Cake           ")
                               .fontWeight(.bold)
                           Image(systemName: "cart.badge.plus")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 24, height: 24)
                           
                       }
                       
                   }
               }
               .padding(4)
               
               
               HStack {
                   
                   VStack{
                       
                       Image(systemName: "camera.on.rectangle")
                           .resizable()
                           .frame(width: 140, height: 90).padding()
                       HStack{
                           
                           Text("Cake           ")
                               .fontWeight(.bold)
                           Image(systemName: "cart.badge.plus")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 24, height: 24)
                           
                       }
                       
                   }
                   
                 
                   VStack{
                       
                       Image(systemName: "camera.on.rectangle")
                           .resizable()
                           .frame(width: 140, height: 90).padding()
                       HStack{
                           
                           Text("Cake           ")
                               .fontWeight(.bold)
                           Image(systemName: "cart.badge.plus")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 24, height: 24)
                           
                       }
                       
                   }
               }
               .padding(4)
    }
}

#Preview {
    RequestFoodListView()
}
