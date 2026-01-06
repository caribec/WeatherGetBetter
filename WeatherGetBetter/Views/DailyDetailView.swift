//
//  DailyDetailView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct DailyDetailView: View {
    // Location this screen should show the 7-day forecast for
    let cityName: String
    let latitude: Double
    let longitude: Double

    // Fetches 7-day forecast data from Open-Meteo
    @StateObject private var weatherAPI = WeatherAPI()

    var body: some View {
        ZStack {
            AppBackground()
            
            content // using content value defined below 
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 24)
        }
        .task {
            //Load 7-day forecast when the view appears
            await weatherAPI.loadRecords(
                latitude: latitude,
                longitude: longitude
            )
        }
        .navigationBarTitleDisplayMode(.inline) //Keeps nav title compact
    }

    //  Content for different states

    @ViewBuilder
    private var content: some View {
        //loading state
        if weatherAPI.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                Text("Loading 7-day forecast…")
                    .font(.system(size: 16, weight: .medium))
            }
            //error state
        } else if let error = weatherAPI.errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .bold))
                Text("Couldn’t load forecast")
                    .font(.system(size: 20, weight: .semibold))
                Text(error)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            //sucess but empty state
        } else if weatherAPI.dailyForecast.isEmpty {
            Text("No forecast available.")
                .font(.system(size: 16, weight: .medium))
            //yay it works
        } else {
            VStack(spacing: 0) {
                // Fixed header
                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundColor(.black.opacity(0.85))
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("7 Day Forecast")
                            .font(.custom("Helvetica Neue", size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text(cityName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black.opacity(0.75))

                    }
                    .padding(.bottom, 10)

                    Spacer()
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)

                // divider under header
                Divider()
                    .opacity(0.3)
                    .padding(.bottom, 8)

                // Scrollable rows
                ScrollView {
                    VStack(spacing: 14) {

                        ForEach(weatherAPI.dailyForecast) { day in
                            DayForecastRow(day: day)
                                .frame(maxWidth: .infinity, alignment: .center)
                            // .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
        }

    }
}

#Preview {
    NavigationStack {
        DailyDetailView(
            cityName: "Houston, Tx",
            latitude: 29.76,
            longitude: -95.37
        )
    }
}
