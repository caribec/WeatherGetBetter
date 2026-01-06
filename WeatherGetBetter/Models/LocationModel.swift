//
//  LocationModel.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import Foundation

struct Location {  //defines location for storing information about a city or place
    let cityName: String
    let stateName: String
    let countryName: String
    var isFavorite: Bool

    init(cityName: String, stateName: String, countryName: String) {
        self.cityName = cityName
        self.stateName = stateName
        self.countryName = countryName
        self.isFavorite = false
    }
}
