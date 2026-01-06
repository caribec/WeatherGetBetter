//
//  HourlyPtModel.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import CoreGraphics
import Foundation

struct HourlyPt: Identifiable, Hashable {
    let id = UUID()
    let t: String
    let y: CGFloat
    let label: String
}
