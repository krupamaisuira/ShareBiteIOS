//
//  DonateFoodView.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import SwiftUI

struct DonateFoodView: View {
    @State private var foodTitle: String = ""
    @State private var discription: String = ""
    var body: some View {
        VStack{
            GeometryReader { geometry in
                ScrollView {
                    Text("Join the Fight Against Hunger")
                        .font(.system(size: 14))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom,10)
                        .padding(.leading,5)
                        .foregroundColor(.black)
                    Text("Photo(s)")
                        .font(.system(size: 14))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.top,3)
                    HStack{
                        
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
                        .font(.system(size:12))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment:.trailing)
                        .padding(.trailing)
                        .foregroundColor(Color.gray)
                    
                    Divider().background(Color.gray).padding(2)
                    HStack{
                        
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            
                        Text("Montreal Quebec H3N 2N6             ")
                            .font(.system(size:16))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    
                    Divider().background(Color.gray).padding(2)
                    
                    Text("Title")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 16))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                        .padding(.leading)
                    
                    
                    TextField("E.g. sandwich, cakes, vegetables", text: $foodTitle)
                        .font(.system(size: 20))
                        .frame(width: 300)
                        .overlay(
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 35)
                        )
                    
                    
                    Divider().background(Color.gray).padding(4)
                    
                    Text("Description")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 16))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                        .padding(.leading)
                    VStack{
                        
                        TextEditor(text: $discription)
                            .padding()
                            .background(Color.white)
                            .border(Color.gray, width: 1)
                            .frame(width: 350, height: 100)
                            .cornerRadius(8)
                        
                    }.padding(7)
                    
                    TextField("Best before", text: $foodTitle)
                        .font(.system(size: 16))
                        .padding(.bottom,25)
                        .frame(width: 350)
                        .overlay(
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 25)
                        )
                    
                    TextField("Price", text: $foodTitle)
                        .font(.system(size: 16))
                        .padding(.bottom,20)
                        .frame(width: 350)
                        .overlay(
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color.gray)
                                .padding(.top, 20)
                        )
                    Text("Price is optional")
                        .font(.system(size:12))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment:.trailing)
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
    }
}
struct DonateFoodView_Preview: PreviewProvider {
    static var previews: some View {
        DonateFoodView()
    }
}

