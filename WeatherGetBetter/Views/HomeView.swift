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
    @State private var isShowingSearch = false
    
    var body: some View {
        ZStack {
            AppBackground()  

            ScrollView {
                VStack(spacing: 20) {
    
                    Text("WeatherGetBetter")
                        .font(.custom("Helvetica Neue", size: 35))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    

                    HStack {
                        
                        NavigationLink(destination: SearchView()) {
                            TextField("Houston, Texas", text: $searchString)
                                .textFieldStyle(.roundedBorder)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                                .padding(.horizontal)
                                .disabled(true) //disabled for the purposes of beta
                        }

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

