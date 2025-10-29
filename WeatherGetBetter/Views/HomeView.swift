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
            HStack() {
                TextField("", text: $searchString)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
                .padding()
            }
            
            GlancePanelView()
                .padding()
            
            Text("Today is a great day to be productive or relax! Be sure to wear sunscreen and drink water if you plan to be out for a while.")
                .italic()
                .frame(width: 275)
                .padding()
                .background() {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.4)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(radius: 10)
                        .frame(width: 300, height: 100)
                }
        }
    }
}

#Preview {
    HomeView()
}
