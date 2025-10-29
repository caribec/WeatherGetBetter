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
        ZStack {
            AppBackground()  // Gradient background

            ScrollView {
                VStack(spacing: 20) {
                    Text("WeatherGetBetter")
                        .font(.title)
                        .bold()
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Palette.accentPrimaryBackground.opacity(0.9),
                                    Palette.accentSecondaryBackground.opacity(0.9)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(.black.opacity(0.25), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                        )


                    HStack {
                        
                        TextField("Search a city...", text: $searchString)
                            .textFieldStyle(.roundedBorder)
                            .clipShape(Capsule())
                            .shadow(radius: 4)
                            .padding(.horizontal)

                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // matches SettingsView icons
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Palette.accentPrimaryBackground.opacity(0.9),
                                            Palette.accentSecondaryBackground.opacity(0.9)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.black.opacity(0.25), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
                                )
                        }
                        .padding(.trailing)
                    }


                    GlancePanelView()
                        .padding()

                    Text("Today is a great day to be productive or relax! Be sure to wear sunscreen and drink water if you plan to be out for a while.")
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Palette.accentPrimaryBackground.opacity(0.9),
                                    Palette.accentSecondaryBackground.opacity(0.9)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(.black.opacity(0.25), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                        )

                        .frame(maxWidth: 300)
                }
                .padding(.top, 24)
                .padding(.bottom, 50)
            }
        }
    }

}

#Preview {
    NavigationStack {
        HomeView()
    }
}

