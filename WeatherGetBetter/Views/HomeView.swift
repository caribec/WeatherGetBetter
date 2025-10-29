//
//  HomeScreenView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI



struct HomeView: View {
    @State private var searchString: String = ""
    
    var body: some View {
        VStack() {
            Text("WeatherGetBetter")
                .font(.title)
                .bold()
                .padding()
                .background(
                    RoundedGradientBackground()
                )

            HStack() {
                
                TextField("", text: $searchString)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(.capsule)
                    .shadow(radius: 4)
                    .padding()
                
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                        .padding(8)
                        .background() {
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 4)
                        }
                }
                .padding()
            }
            
            GlancePanelView()
                .padding()
            
            Text("Today is a great day to be productive or relax! Be sure to wear sunscreen and drink water if you plan to be out for a while.")
                .italic()
                .frame(width: 275)
                .padding()
                .background(
                    RoundedGradientBackground()
                )
                
                
        }
    }
}

#Preview {
    HomeView()
}
