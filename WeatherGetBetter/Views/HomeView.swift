//
//  HomeScreenView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI



struct HomeView: View {
    @State private var searchString: String = ""
    @State private var showingFavorites = false
    
    var body: some View {
        ZStack {
            AppBackground()  // Gradient background

            ScrollView {
                VStack(spacing: 20) {
                    // Title (Helvetica Neue) aligned with search field's left edge
                    Text("WeatherGetBetter")
                        .font(.custom("Helvetica Neue", size: 35))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    

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
                    // NEW: Go to Favorites button
                            Button {
                                showingFavorites = true
                            } label: {
                                Label("Go to Favorites", systemImage: "heart.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Palette.accentPrimaryBackground.opacity(0.95),
                                                        Palette.accentSecondaryBackground.opacity(0.95)
                                                    ],
                                                    startPoint: .top, endPoint: .bottom
                                                )
                                            )
                                            .overlay(Capsule().stroke(.black.opacity(0.2), lineWidth: 1))
                                            .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                                    )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

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
                // Shared horizontal padding keeps title and search perfectly aligned
                 .padding(.horizontal, 18)
                 .padding(.top, 24)
                 .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesSheet()
                .presentationDetents([.medium, .large])
        }
    }
}

// Simple favorites sheet showing Houston with a red heart
struct FavoritesSheet: View {
    var body: some View {
        NavigationStack {
            List {
                HStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("Houston, TX")
                        .font(.system(size: 18, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

