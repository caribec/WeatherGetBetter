//
//  DayForecastModel.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import Foundation

struct DayForecast: Identifiable, Hashable, Codable {
    let id = UUID()
    let label: String      // "Today", "Sat", etc.
    let symbol: String     // SF Symbol name, e.g. "sun.max.fill"
    let temp: Int          // 75
    let precip: Int        // percent
    let humidity: Int      // percent
    let wind: Int          // mph
}
