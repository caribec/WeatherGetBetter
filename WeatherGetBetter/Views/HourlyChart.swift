//
//  HourlyChart.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

struct HourlyChart: View {
    let series: [HourlyPt]
    let lineColor: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let pad: CGFloat = 28
            let xStep = (w - 2*pad) / CGFloat(max(series.count - 1, 1))

            ZStack {
                // axes
                Path { p in
                    p.move(to: CGPoint(x: pad, y: pad))
                    p.addLine(to: CGPoint(x: pad, y: h - pad))
                    p.addLine(to: CGPoint(x: w - pad, y: h - pad))
                }
                .stroke(.black.opacity(0.6), lineWidth: 1)

                // line
                Path { p in
                    for i in series.indices {
                        let x = pad + CGFloat(i) * xStep
                        let y = pad + series[i].y * (h - 2*pad)   // flip to (1 - y) if desired
                        if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                        else { p.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                .animation(.easeInOut(duration: 0.25), value: series)

                // points + labels
                ForEach(Array(series.enumerated()), id: \.element.id) { i, pt in
                    let x = pad + CGFloat(i) * xStep
                    let y = pad + pt.y * (h - 2*pad)

                    Circle()
                        .fill(lineColor)
                        .frame(width: 10, height: 10)
                        .position(x: x, y: y)

                    Text(pt.label)
                        .font(.caption)
                        .foregroundColor(.black)
                        .position(x: x, y: y - 16)

                    Text(pt.t)
                        .font(.caption2)
                        .foregroundColor(.black)
                        .position(x: x, y: h - pad + 12)
                }
            }
        }
    }
}


#Preview {
    let sample: [HourlyPt] = [
        .init(t: "12 PM", y: 0.30, label: "75°"),
        .init(t: "1 PM",  y: 0.20, label: "78°"),
        .init(t: "2 PM",  y: 0.35, label: "76°"),
        .init(t: "3 PM",  y: 0.45, label: "74°")
    ]

    return ZStack {
        AppBackground()
        HourlyChart(series: sample, lineColor: .black)
            .frame(width: 340, height: 200)
            .padding()
    }
}
