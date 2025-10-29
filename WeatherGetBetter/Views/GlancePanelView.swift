//
//  GlancePanelView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct GlancePanelView: View {
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("Friday")
                Text("12:30 pm")
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("75")
                            .font(.system(size: 64, weight: .bold))
                        Text("°F")
                            .font(.system(size: 28, weight: .semibold)) // smaller unit
                            .baselineOffset(30) // nudge up so it sits nicely
                    }

                    Text("H: 78° - L: 70°")
                        .font(.system(size: 16, weight: .medium))
                }

                Image(systemName: "sun.max.fill")
                    .resizable()
                    .shadow(radius: 2)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .padding(.leading, 16)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 30) {
                VStack {
                    Image(systemName: "wind")
                        .font(.system(size: 32))
                    Text("7 mph")
                        .font(.caption)
                }
                
                VStack {
                    Image(systemName: "cloud.rain")
                        .font(.system(size: 32))
                    Text("15%")
                        .font(.caption)
                }
                
                VStack {
                    Image(systemName: "humidity")
                        .font(.system(size: 32))
                    Text("65%")
                        .font(.caption)
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [
                    Palette.accentPrimaryBackground.opacity(0.9),
                    Palette.accentSecondaryBackground.opacity(0.9)
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
    GlancePanelView()
}
