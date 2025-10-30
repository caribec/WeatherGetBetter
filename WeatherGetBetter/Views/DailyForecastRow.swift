//
//  DailyForecastRow.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

struct DayForecastRow: View {
    let day: DayForecast

    // tweaks the row width
    private let leftClusterWidth: CGFloat = 170    // total width for day + icon + temp
    private let dayLabelWidth: CGFloat   = 64      // space reserved for "Today"
    private let iconSize: CGFloat        = 20

    var body: some View {
        HStack(spacing: 14) {

            // fixed width keeps all rows aligned
            HStack(spacing: 12) {
                Text(day.label)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: dayLabelWidth, alignment: .leading) // more room for "Today"

                Image(systemName: day.symbol)
                    .foregroundColor(.yellow)
                    .font(.system(size: iconSize, weight: .semibold))
                    .frame(width: iconSize, height: iconSize)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(day.temp)")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.black)
                    Text("°F")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                        .baselineOffset(18) 
                }
            }
            .frame(width: leftClusterWidth, alignment: .leading)

            Spacer(minLength: 8)

            // Right
            VStack(alignment: .trailing, spacing: 4) {
                Text("Precipitation: \(day.precip)%")
                Text("Humidity: \(day.humidity)%")
                Text("Wind: \(day.wind) mph")
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
                    Palette.accentSecondaryBackground.opacity(0.95)
                ],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.black.opacity(0.25), lineWidth: 1))
            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        )
    }
}

#Preview {
    DayForecastRow(
        day: .init(label: "Today", symbol: "sun.max.fill", temp: 75, precip: 0, humidity: 32, wind: 7)
    )
    .padding()
    .background(AppBackground())
}

