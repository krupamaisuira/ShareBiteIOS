//
//  request_food.swift
//  ShareBiteApp
//
//  Created by User on 2024-07-19.
//

import SwiftUI

struct request_food: View {
    
    
    var body: some View {
        
        Text("Your request is confirmed!")
            .font(.system(size: 25))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(.bottom, 2)
            .foregroundColor(.black)

        Text("We have received your food request.A confirmation code has been sent to your phone via SMS")
            .font(.subheadline)
            .foregroundColor(.black)
            .bold()
            .padding(.bottom, 10)
            .multilineTextAlignment(.center)
        Text("Instructions")
            .font(.system(size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        
        Divider().background(Color.gray)
        
        HStack(alignment: .top) {
            Text("=>")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Text("Head to the pickup location specified in the food item details")
                .font(.system(size: 17))
        }.padding(.bottom, 8)
        
        HStack(alignment: .top) {
            Text("  =>")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Text("Show the confirmation code you received via SMS to the staff at the pickup location")
                .font(.system(size: 17))
        }.padding(.bottom, 8)
        Text("Pickup Location : Monteal , Quebec, H3N 2N6")
            .font(.system(size:17))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(.bottom, 2)
            .foregroundColor(.black)

        HStack(alignment: .top) {
            Text("=> ")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Text("Collect your requested food items")
                .font(.system(size: 18))
                .padding(.trailing,50)
        }.padding(.bottom, 8)
        
        Text("Both you and the donor will receive a notification with the same confirmation code to ensure a smooth handover.")
            .font(.system(size: 18)).padding()
        
        Divider().background(Color.gray)
        
        Text("If you have any questions or issues, please contact us at\n+1 454 111 1111\nemail@gmail.com")
            .font(.system(size: 18))
            .padding()
        
        NavigationLink(destination: DashboardView()) {
            Text("Home")
                .frame(maxWidth: 140, maxHeight: 10)
                .padding()
                .background(Color.cyan)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
        
      
        
        
        
           
        
    }
}

#Preview {
    request_food()
}
