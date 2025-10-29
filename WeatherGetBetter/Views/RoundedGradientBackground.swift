//
//  RoundedGradientBackground.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct RoundedGradientBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 2)
            )
    }
}

#Preview {
    RoundedGradientBackground()
}
