//
//  HourlyDetailView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct HourlyDetailView: View {
    
    @State private var selection = 1
    @State private var searchString: String = ""
    
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: "clock")
                Text("Hourly Forecast")
                    .bold()
            }
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
            
            Picker("", selection: $selection) {
                Text("Temp").tag(1)
                Text("Precipitation").tag(2)
                Text("Humidity").tag(3)
                Text("Wind").tag(4)
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    HourlyDetailView()
}
