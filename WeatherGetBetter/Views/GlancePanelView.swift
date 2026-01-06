//
//  GlancePanelView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

// Icon helper

private func getWeatherIcon(for code: Int) -> (name: String, color: Color) {
    switch code {
    case 0:  // Clear sky
        return (name: "sun.max.fill", color: .yellow)
    case 1...3:  // Mainly clear, partly cloudy, overcast
        return (name: "cloud.sun.fill", color: .orange)
    case 45...48:  // Fog and depositing rime fog
        return (name: "cloud.fog.fill", color: .gray)
    case 51...57:  // Drizzle and Rain (light to heavy)
        return (name: "cloud.drizzle.fill", color: .blue)
    case 61...67:  // Rain (light, moderate, heavy)
        return (name: "cloud.rain.fill", color: .blue)
    case 71...77:  // Snow fall
        return (name: "cloud.snow.fill", color: .white)
    case 80...82:  // Rain showers
        return (name: "cloud.heavyrain.fill", color: .blue)
    case 85...86:  // Snow showers
        return (name: "snow", color: .white)
    case 95:  // Thunderstorm
        return (name: "cloud.bolt.fill", color: .gray)
    case 96...99:  // Thunderstorm with hail
        return (name: "cloud.bolt.rain.fill", color: .gray)
    default:
        return (name: "questionmark.circle", color: .black)
    }
}

// Unit conversion

private func celsiusToFahrenheit(_ c: Double) -> Double {
    c * 9.0 / 5.0 + 32.0
}

private func kmhToMph(_ k: Double) -> Double {
    k * 0.621371
}
//Formats the wind into correct unit string
private func formattedWind(_ kmh: Double, useImperial: Bool) -> String {
    let value = useImperial ? kmhToMph(kmh) : kmh
    let unit = useImperial ? "mph" : "km/h"
    return "\(Int(round(value))) \(unit)"
}

//View

struct GlancePanelView: View {
    // The hourly weather model passed in from HomeView
    var weatherForecast: WeatherRecord

    //Used to toggle between Celsius & Fahrenheit via SettingsView
    @AppStorage("useImperial") private var useImperial: Bool = true

    // used for getting current date and time
    private var currentDateTime: (day: String, time: String) {
        let currentDate = Date()

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"  //current day

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"  //current time

        return (
            day: dayFormatter.string(from: currentDate),
            time: timeFormatter.string(from: currentDate)
        )
    }

    //Todayshigh/low only from hourly data
    private var todayHighLow: (high: Double, low: Double)? {

        let today = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = .current
        let todayPrefix = df.string(from: today)

        var todaysTemps: [Double] = []
        
        // Filter hourly temperatures only from today
        for (index, ts) in weatherForecast.time.enumerated() {
            guard index < weatherForecast.temperature.count else { break }

            if ts.hasPrefix(todayPrefix) {
                todaysTemps.append(weatherForecast.temperature[index])
            }
        }

        guard let maxTemp = todaysTemps.max(),
            let minTemp = todaysTemps.min()
        else {
            return nil
        }
        return (high: maxTemp, low: minTemp)
    }

    var body: some View {

        VStack(spacing: 16) {

            // Date + time
            HStack {
                Text(currentDateTime.day)
                Text(currentDateTime.time)
            }

            // Current temp and icon
            HStack {
                if let current = weatherForecast.currentForecast {
                    VStack(alignment: .leading, spacing: 4) {
                        // Big current temp
                        let mainC = current.temp
                        let mainDisplay =
                            useImperial ? celsiusToFahrenheit(mainC) : mainC
                        let unitSymbol = useImperial ? "°F" : "°C"

                        HStack(alignment: .firstTextBaseline, spacing: 3) {
                            Text("\(Int(round(mainDisplay)))")
                                .font(.system(size: 64, weight: .bold))
                            Text(unitSymbol)
                                .font(.system(size: 28, weight: .semibold))
                                .baselineOffset(30)
                        }

                        // Today high/low
                        let hiLo = todayHighLow ?? (high: mainC, low: mainC)
                        let highDisplay =
                            useImperial
                            ? celsiusToFahrenheit(hiLo.high) : hiLo.high
                        let lowDisplay =
                            useImperial
                            ? celsiusToFahrenheit(hiLo.low) : hiLo.low

                        Text(
                            "H: \(Int(round(highDisplay)))\(unitSymbol) - L: \(Int(round(lowDisplay)))\(unitSymbol)"
                        )
                        .font(.system(size: 16, weight: .medium))
                    }

                    // Icon from current code
                    let weatherImage = getWeatherIcon(for: current.code)

                    Image(systemName: weatherImage.name)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 2)
                        .frame(width: 100, height: 100)
                        .foregroundColor(weatherImage.color)
                        .padding(.leading, 16)
                } else {
                    Text("No current weather data.")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(.bottom, 8)

            // Wind / precip / humidity
            HStack(spacing: 30) {
                VStack {
                    Image(systemName: "wind")
                        .font(.system(size: 32))
                    Text(
                        formattedWind(
                            weatherForecast.windSpeed.first ?? 0,
                            useImperial: useImperial
                        )
                    )
                    .font(.caption)
                }

                VStack {
                    Image(systemName: "cloud.rain")
                        .font(.system(size: 32))
                    Text(
                        "\(Int(weatherForecast.precipitationProb.first ?? 0))%"
                    )
                    .font(.caption)
                }

                VStack {
                    Image(systemName: "humidity")
                        .font(.system(size: 32))
                    Text("\(Int(weatherForecast.humidity.first ?? 0))%")
                        .font(.caption)
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [
                    Palette.accentPrimaryBackground.opacity(0.9),
                    Palette.accentSecondaryBackground.opacity(0.9),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.black.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 10, y: 6)
        )
    }
}

#Preview {
    let record: WeatherRecord = WeatherRecord(
        latitude: 29.767237,
        longitude: -95.35445,
        time: [
            "2025-11-30T00:00", "2025-11-30T01:00", "2025-11-30T02:00",
            "2025-11-30T03:00", "2025-11-30T04:00", "2025-11-30T05:00",
            "2025-11-30T06:00", "2025-11-30T07:00", "2025-11-30T08:00",
            "2025-11-30T09:00", "2025-11-30T10:00", "2025-11-30T11:00",
            "2025-11-30T12:00", "2025-11-30T13:00", "2025-11-30T14:00",
            "2025-11-30T15:00", "2025-11-30T16:00", "2025-11-30T17:00",
            "2025-11-30T18:00", "2025-11-30T19:00", "2025-11-30T20:00",
            "2025-11-30T21:00", "2025-11-30T22:00", "2025-11-30T23:00",
        ],
        temperature: [
            20.9, 20.9, 20.8, 20.4, 19.8, 20.1, 20.1, 20.6, 20.1, 17.9, 16.5,
            14.1, 13.3, 12.3, 12.1, 12.2, 10.9, 10.4, 9.5, 9.6, 9.3, 9.2, 9.2,
            9.1,
        ],
        precipitationProb: [
            19.0, 20.0, 24.0, 24.0, 26.0, 32.0, 30.0, 39.0, 44.0, 69.0, 94.0,
            84.0, 67.0, 37.0, 19.0, 26.0, 10.0, 6.0, 6.0, 1.0, 1.0, 1.0, 1.0,
            1.0,
        ],
        windSpeed: [
            9.7, 4.5, 8.2, 5.0, 8.4, 8.9, 7.1, 7.3, 7.9, 8.9, 11.6, 18.9, 18.5,
            18.3, 20.3, 17.3, 17.0, 17.7, 22.0, 19.5, 17.7, 17.8, 16.3, 16.8,
        ],
        humidity: [
            81.0, 78.0, 85.0, 84.0, 84.0, 90.0, 90.0, 88.0, 94.0, 100.0, 97.0,
            94.0, 94.0, 90.0, 93.0, 92.0, 95.0, 89.0, 91.0, 86.0, 89.0, 87.0,
            87.0, 86.0,
        ],
        weatherCode: [
            3, 3, 3, 0, 1, 3, 3, 3, 51, 53, 65, 65, 51, 3, 3, 3, 3, 3, 3, 3, 3,
            3, 3, 3,
        ]
    )
    GlancePanelView(weatherForecast: record)
}
