//
//  DailyDetailView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct DailyDetailView: View {
    @State private var query = "Houston, TX"

    // sample rows for the UI
    private let days: [DayForecast] = [
        .init(label: "Today", symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7),
        .init(label: "Sat",   symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7),
        .init(label: "Sun",   symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7),
        .init(label: "Mon",   symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7),
        .init(label: "Tue",   symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7),
    ]

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 20) {

                    // Title pill
                    HStack(spacing: 10) {
                        Image(systemName: "calendar")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.black.opacity(0.85))
                        Text("5 Day Forecast")
                            .font(.custom("Helvetica Neue", size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)


                    // Search + Gear row
 
                    HStack(spacing: 12) {
                        // Non-functional search bar 
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.red)
                            Text("Houston")
                                .foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(.systemBackground).opacity(0.9))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(.black.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                        )
                        .padding(.horizontal)



                        // Gear button styled
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(
                                    LinearGradient(
                                        colors: [Palette.accentPrimaryBackground, Palette.accentSecondaryBackground],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.black.opacity(0.25), lineWidth: 1))
                                    .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
                                )
                        }
                    }

                    // Forecast cards
                    VStack(spacing: 14) {
                        ForEach(days) { day in
                            DayForecastRow(day: day)
                        }
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    NavigationStack { DailyDetailView() }
}
