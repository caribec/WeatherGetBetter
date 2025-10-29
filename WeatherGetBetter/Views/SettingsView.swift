//
//  SettingsView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var useImperial = true

    var body: some View {
        ZStack {
            AppBackground()
 
            // Scrollable content only
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title pill
                    Text("Settings")
                        .font(.system(size: 28, weight: .black))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [
                                    Palette.accentPrimaryBackground,
                                    Palette.accentSecondaryBackground
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(.black.opacity(0.25), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                        )
                    // Toggle card
                    HStack {
                        Text("Toggle Imperial/Metric")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                           

                        Spacer()
                        
                        Toggle("", isOn: $useImperial)
                            .labelsHidden()
                        //makes it green when on
                            .tint(.green)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(
                        LinearGradient(
                            colors: [
                                Palette.accentPrimaryBackground.opacity(0.9),
                                Palette.accentSecondaryBackground.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                    )
                    // About card
                    // About card
                    VStack(alignment: .center, spacing: 14) {

                        // Info icon
                        ZStack {
                            Circle()
                                .stroke(.black.opacity(0.25), lineWidth: 2)
                                .frame(width: 60, height: 60)

                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(.black.opacity(0.85))
                        }

                        Text("ABOUT")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)

                        Text("This application assists users all over the world and provides on-the-go data to help make their day better.")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)

                        Text("Made with SwiftUI")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
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
                .padding(24)
                .padding(.top, 72) // leavesspace  so content doesn't sit under the back button
            }
        }
        // Pin the back button to the top-left above everything
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(Circle().stroke(.black.opacity(0.25), lineWidth: 1))
                        .frame(width: 48, height: 48)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black.opacity(0.85))
                }
            }
            .buttonStyle(.plain)
            .padding(.leading, 24)
            .padding(.top, 18) //
        }
        .tint(Palette.accentPrimary)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsView()
}
