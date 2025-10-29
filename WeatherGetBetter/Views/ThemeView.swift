//
//  ThemeView.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//


import SwiftUI

struct Palette {
    static let accentPrimary   = Color("AccentPrimary")     // #74BDE5
    static let accentSecondary = Color("AccentSecondary")   // #06528D
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Palette.accentPrimary, Palette.accentSecondary],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview { AppBackground() }


