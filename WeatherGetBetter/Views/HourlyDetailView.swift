//
//  HourlyDetailView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct HourlyDetailView: View {
    @State private var metric: Metric = .temp
    @State private var query = "Houston, TX"

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 20) {

                    // Title pill
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.black.opacity(0.85))
                        Text("Hourly Forecast")
                            .font(.custom("Helvetica Neue", size: 35))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                        
                    }


                    // Search + Gear row
                    HStack(spacing: 12) {
                        // Non-functional search bar (visual only)
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

                    // Segmented control
                    Picker("", selection: $metric) {
                        Text("Temp").tag(Metric.temp)
                        Text("Precipitation").tag(Metric.precip)
                        Text("Humidity").tag(Metric.humidity)
                        Text("Wind").tag(Metric.wind)
                    }
                    .pickerStyle(.segmented)
                    .animation(.easeInOut(duration: 0.25), value: metric)
                    .padding(.horizontal, 6)
                    .background(
                        LinearGradient(
                            colors: [Palette.accentPrimaryBackground, Palette.accentSecondaryBackground],
                            startPoint: .top, endPoint: .bottom
                        )
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.black.opacity(0.25), lineWidth: 1))
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
                    )

                    // Chart card
                    VStack {
                        HourlyChart(series: series(for: metric), lineColor: color(for: metric))
                            .frame(height: 180)
                            .padding(Edge.Set.horizontal, 12) // explicit to avoid inference error
                    }
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Palette.accentPrimaryBackground.opacity(0.95),
                                     Palette.accentSecondaryBackground.opacity(0.95)],
                            startPoint: .top, endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.black.opacity(0.25), lineWidth: 1))
                        .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                    )

                    // Advisory card
                    Text(advisory(for: metric))
                        .font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                        .padding(18)
                        .background(
                            LinearGradient(
                                colors: [Palette.accentPrimaryBackground, Palette.accentSecondaryBackground],
                                startPoint: .top, endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.black.opacity(0.25), lineWidth: 1))
                            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
    }
}


enum Metric: Int, CaseIterable {
    case temp = 1, precip, humidity, wind

    var title: String {
        switch self {
        case .temp: return "Temp"
        case .precip: return "Precipitation"
        case .humidity: return "Humidity"
        case .wind: return "Wind"
        }
    }
}

private func series(for metric: Metric) -> [HourlyPt] {
    switch metric {
    case .temp:
        return [
            .init(t: "12 PM", y: 0.30, label: "75°"),
            .init(t: "1 PM",  y: 0.20, label: "78°"),
            .init(t: "2 PM",  y: 0.35, label: "76°"),
            .init(t: "3 PM",  y: 0.45, label: "74°")
        ]
    case .precip:
        return [
            .init(t: "12 PM", y: 0.10, label: "10%"),
            .init(t: "1 PM",  y: 0.15, label: "15%"),
            .init(t: "2 PM",  y: 0.05, label: "5%"),
            .init(t: "3 PM",  y: 0.18, label: "18%")
        ]
    case .humidity:
        return [
            .init(t: "12 PM", y: 0.60, label: "60%"),
            .init(t: "1 PM",  y: 0.64, label: "64%"),
            .init(t: "2 PM",  y: 0.58, label: "58%"),
            .init(t: "3 PM",  y: 0.62, label: "62%")
        ]
    case .wind:
        return [
            .init(t: "12 PM", y: 0.25, label: "6 mph"),
            .init(t: "1 PM",  y: 0.35, label: "8 mph"),
            .init(t: "2 PM",  y: 0.30, label: "7 mph"),
            .init(t: "3 PM",  y: 0.40, label: "9 mph")
        ]
    }
}

private func color(for metric: Metric) -> Color {
    switch metric {
    case .temp: return .blue
    case .precip: return .teal
    case .humidity: return .indigo
    case .wind: return .purple
    }
}

private func advisory(for: Metric) -> String {
    switch `for` {
    case .temp:
        return "Temperatures will reach up to 78° within the next few hours. It is advised to drink plenty of water."
    case .precip:
        return "Light rain chances vary through the afternoon. Keep an umbrella handy if you will be outside."
    case .humidity:
        return "Humidity stays elevated; plan for a muggy feel. Consider lighter clothing if outdoors."
    case .wind:
        return "Wind picks up later today. Secure loose items and be cautious on open roads."
    }
}

#Preview {
    NavigationStack { HourlyDetailView() }
}

