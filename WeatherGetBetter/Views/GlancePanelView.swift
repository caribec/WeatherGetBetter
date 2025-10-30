//
//  GlancePanelView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct GlancePanelView: View {
    var body: some View {
            
        VStack() {
            
            HStack() {
                Text("Friday")
                Text("12:30 pm")
            }
            
            HStack() {
                VStack() {
                    Text("75°F")
                        .bold()
                        .font(.system(size: 64))
                    Text("H: 78° - L: 70°")
                    
                }
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .shadow(radius: 2)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.yellow)
                    .padding()
                
            }
            .padding()
            
            HStack() {
                VStack() {
                    Image(systemName: "wind")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("7 mph")
                        .font(.caption)
                }
                .padding(.horizontal)
                VStack() {
                    Image(systemName: "cloud.rain")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("7 mph")
                        .font(.caption)
                }
                .padding(.horizontal)
                VStack() {
                    Image(systemName: "humidity")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("7 mph")
                        .font(.caption)
                }
                .padding(.horizontal)
            }
            
        }
        
        
        .padding()
        .background(
            RoundedGradientBackground()
        )
                
    }
}

#Preview {
    GlancePanelView()
}
