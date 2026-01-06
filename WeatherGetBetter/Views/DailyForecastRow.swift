//
//  DailyForecastRow.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

// Converts °C to °F
private func celsiusToFahrenheit(_ c: Double) -> Double {
    c * 9.0 / 5.0 + 32.0
}
// Converts km/h to mph
private func kmhToMph(_ k: Double) -> Double {
    k * 0.621371
}
// Maps to the symbol
private func getWeatherIcon(for symbol: String) -> (name: String, color: Color)
{
    switch symbol {

    case "sun.max.fill":
        return ("sun.max.fill", .yellow)

    case "cloud.sun.fill":
        return ("cloud.sun.fill", .orange)

    case "cloud.fill":
        return ("cloud.fill", .gray)

    case "cloud.fog.fill":
        return ("cloud.fog.fill", .gray)

    case "cloud.drizzle.fill":
        return ("cloud.drizzle.fill", .blue)

    case "cloud.rain.fill":
        return ("cloud.rain.fill", .blue)

    case "cloud.snow.fill":
        return ("cloud.snow.fill", .white)

    case "cloud.heavyrain.fill":
        return ("cloud.heavyrain.fill", .blue)

    case "cloud.bolt.rain.fill":
        return ("cloud.bolt.rain.fill", .gray)

    default:
        return (symbol, .black)  // fallback
    }
}

// Displays a single day's weather card in the 7-day forecast list
struct DayForecastRow: View {
    //The data
    let day: DayForecast

    @AppStorage("useImperial") private var useImperial: Bool = true

    // tweaks the row width
    private let leftClusterWidth: CGFloat = 170  //keeps the entire left side the same width on every row so columns line up
    private let dayLabelWidth: CGFloat = 64  //enough room for Today so the label doesn’t bump other items
    private let iconSize: CGFloat = 20  //consistent SF Symbol size

    var body: some View {
        HStack(spacing: 14) {

            // fixed width keeps all rows aligned
            HStack(spacing: 12) {
                Text(day.label)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: dayLabelWidth, alignment: .leading)  // more room for "Today"

                Image(systemName: getWeatherIcon(for: day.symbol).name)
                    .foregroundColor(getWeatherIcon(for: day.symbol).color)
                    .font(.system(size: iconSize, weight: .semibold))
                    .frame(width: iconSize, height: iconSize)

                // Temperature, converted based on toggle
                let tempC = Double(day.temp)  // stored as °C
                let displayTemp =
                    useImperial ? celsiusToFahrenheit(tempC) : tempC
                let unitSymbol = useImperial ? "°F" : "°C"

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(round(displayTemp)))")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.black)

                    Text(unitSymbol)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                        .baselineOffset(18)
                }
            }
            .frame(width: leftClusterWidth, alignment: .leading)

            Spacer(minLength: 8)

            // Right details
            VStack(alignment: .trailing, spacing: 4) {
                Text("Max Precipitation: \(day.precip)%")
                Text("Max Humidity: \(day.humidity)%")

                // Wind, converted based on toggle
                let windKmh = Double(day.wind)
                let windDisplay = useImperial ? kmhToMph(windKmh) : windKmh
                let windUnit = useImperial ? "mph" : "km/h"

                Text("Max Wind: \(Int(round(windDisplay))) \(windUnit)")
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.black.opacity(0.9))
            .frame(minWidth: 140, alignment: .trailing)

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    Palette.accentPrimaryBackground.opacity(0.95),
                    Palette.accentSecondaryBackground.opacity(0.95),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(
                    .black.opacity(0.25),
                    lineWidth: 1
                )
            )

        )
    }
}

#Preview {
    DayForecastRow(
        day: .init(
            label: "Today",
            symbol: "sun.max.fill",
            temp: 75,
            precip: 0,
            humidity: 32,
            wind: 7
        )
    )
    .padding()
    .background(AppBackground())
}
