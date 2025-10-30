//
//  HourlyPtModel.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import Foundation
import CoreGraphics  // for CGFloat

struct HourlyPt: Identifiable, Hashable {
    let id = UUID()
    let t: String     // x-axis label, e.g. "12 PM"
    let y: CGFloat    // normalized 0...1 position
    let label: String // point label, e.g. "75°"
}
