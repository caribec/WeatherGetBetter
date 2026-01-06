//
//  HourlyChart.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

//line chart for hourly data
struct HourlyChart: View {
    let series: [HourlyPt]  //Points to plot
    let lineColor: Color  //Color for line and points

    var body: some View {
        GeometryReader { geo in
            // Chart layout sizes
            let w = geo.size.width
            let h = geo.size.height
            let pad: CGFloat = 28
            let pointSpacing: CGFloat = 35.0

            // Total width needed to display all points horizontally
            let contentWidth: CGFloat =
                pad + CGFloat(series.count - 1) * pointSpacing + pad

            ScrollView(.horizontal) {
                ZStack {
                    // axes
                    Path { p in
                        p.move(to: CGPoint(x: pad, y: pad))
                        // Draw a line straight down
                        p.addLine(to: CGPoint(x: pad, y: h - pad))
                        // draw a line to the right
                        p.addLine(
                            to: CGPoint(x: contentWidth - pad, y: h - pad)
                        )
                    }
                    .stroke(.black.opacity(0.6), lineWidth: 1)

                    // Line connecting points
                    Path { p in
                        for i in series.indices {
                            let x = pad + CGFloat(i) * pointSpacing
                            //
                            let y = h - pad - series[i].y * (h - 2 * pad)

                            if i == 0 {
                                p.move(to: CGPoint(x: x, y: y))
                            } else {
                                p.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(
                        lineColor,
                        style: StrokeStyle(lineWidth: 2, lineJoin: .round)
                    )
                    // Animate
                    .animation(.easeInOut(duration: 0.5), value: series)

                    // points & labels
                    ForEach(Array(series.enumerated()), id: \.element.id) {
                        i,
                        pt in
                        let x = pad + CGFloat(i) * pointSpacing
                        // Match y
                        let y = h - pad - pt.y * (h - 2 * pad)

                        // Point dot
                        Circle()
                            .fill(lineColor)
                            .frame(width: 10, height: 10)
                            .position(x: x, y: y)

                        // Value label

                        Text(pt.label)
                            .font(.caption)
                            .foregroundColor(.black)
                            .position(x: x, y: y - 16)

                        // Time label -- shows only every 4th hour
                        if i % 4 == 0 {
                            Text(pt.t)
                                .font(.caption2)
                                .foregroundColor(.black)
                                .position(x: x, y: h - pad + 12)
                        }
                    }
                }
                .frame(width: contentWidth, height: h)
            }
            //.padding(.leading, pad)
            .scrollIndicators(.visible)
        }
    }
}

#Preview {
    let sample: [HourlyPt] = [
        .init(t: "12 PM", y: 0.30, label: "75°"),
        .init(t: "1 PM", y: 0.20, label: "78°"),
        .init(t: "2 PM", y: 0.35, label: "76°"),
        .init(t: "3 PM", y: 0.45, label: "74°"),
        .init(t: "4 PM", y: 0.30, label: "75°"),
        .init(t: "5 PM", y: 0.20, label: "78°"),
        .init(t: "6 PM", y: 0.35, label: "76°"),
        .init(t: "7 PM", y: 0.45, label: "74°"),
        .init(t: "8 PM", y: 0.30, label: "75°"),
        .init(t: "9 PM", y: 0.20, label: "78°"),
        .init(t: "10 PM", y: 0.35, label: "76°"),
        .init(t: "11 PM", y: 0.45, label: "74°"),
        .init(t: "12 AM", y: 0.30, label: "75°"),
        .init(t: "1 AM", y: 0.20, label: "78°"),
        .init(t: "2 AM", y: 0.35, label: "76°"),
        .init(t: "3 AM", y: 0.45, label: "74°"),
        .init(t: "4 AM", y: 0.30, label: "75°"),
        .init(t: "5 AM", y: 0.20, label: "78°"),
        .init(t: "6 AM", y: 0.35, label: "76°"),
        .init(t: "7 AM", y: 0.45, label: "74°"),
        .init(t: "8 AM", y: 0.30, label: "75°"),
        .init(t: "9 AM", y: 0.20, label: "78°"),
        .init(t: "10 AM", y: 0.35, label: "76°"),
        .init(t: "11 AM", y: 0.45, label: "74°"),
    ]

    return ZStack {
        AppBackground()
        HourlyChart(series: sample, lineColor: .black)
            .frame(width: 340, height: 200)
            .padding()
    }
}
