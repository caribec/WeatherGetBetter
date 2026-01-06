//
//  HourlyDetailView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct HourlyDetailView: View {
    //  metric the user is viewing on the chart
    @State private var metric: Metric = .temp
    @EnvironmentObject var selectionManager: AppSelectionManager
    @StateObject private var weatherAPI = WeatherAPI()
    @AppStorage("useImperial") private var useImperial: Bool = true

    @State private var hasScrolledChart: Bool = false

    let cityName: String
    private var currentForecast: WeatherRecord { weatherAPI.currentForecast }
    //ata series for the chart, based on the selected metric and units
    private var chartSeries: [HourlyPt] {
        series(for: metric, record: currentForecast, useImperial: useImperial)
    }
    //picker that lets the user pick Temp / Precipitation / Humidity / Wind
    fileprivate func MetricPicker() -> some View {
        return Picker("", selection: $metric) {
            Text("Temp").tag(Metric.temp)
            Text("Precipitation").tag(Metric.precip)
            Text("Humidity").tag(Metric.humidity)
            Text("Wind").tag(Metric.wind)
        }
        .pickerStyle(.segmented)
        .animation(.easeInOut(duration: 0.25), value: metric)
        .padding(.horizontal, 6)
        .background(
            LinearGradient(
                colors: [
                    Palette.accentPrimaryBackground,
                    Palette.accentSecondaryBackground,
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.black.opacity(0.25), lineWidth: 1))
            .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
        )
    }
    //contains the horizontally scrollable line chart
    fileprivate func ChartCard() -> some View {
        VStack(spacing: 8) {
            // Horizontal scroll view
            ScrollView(.horizontal, showsIndicators: true) {
                HourlyChart(
                    series: chartSeries,
                    lineColor: color(for: metric)
                )
                .frame(
                    //  each hour gets 60–80 pts of width so it feels long, like the mock
                    width: max(CGFloat(chartSeries.count) * 40, 360),
                    height: 260
                )
                .padding(.horizontal, 12)
            }
             //Track when the user scrolls the chart; once they do, hide the hint text
            .simultaneousGesture(
                DragGesture().onChanged { _ in
                    if !hasScrolledChart {
                        withAnimation(.easeOut(duration: 0.3)) {
                            hasScrolledChart = true
                        }
                    }
                }
            )

            // text for user to scroll
            if !hasScrolledChart {
                Text("See more details →")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.6))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                //.top move it down from the top
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
        .background(
            //Big rounded card
            LinearGradient(
                colors: [
                    Palette.accentPrimaryBackground.opacity(0.95),
                    Palette.accentSecondaryBackground.opacity(0.95),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.black.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        )
    }

    var body: some View {

        ZStack {
            AppBackground()

            VStack(spacing: 0) {

                VStack(spacing: 5) {
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(.black.opacity(0.85))
                            .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hourly Forecast")
                                .font(.custom("Helvetica Neue", size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            Text(cityName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black.opacity(0.75))

                        }
                        
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                }
                

                ScrollView {
                    
                    // fetch data for the selected city
                    if weatherAPI.isLoading {
                        LoadingView()
                    } else {
                        MetricPicker()
                            .padding()
                        
                        // Line chart card
                        ChartCard()
                            .padding()

                        HourlyGlanceView(
                            record: currentForecast,
                            useImperial: useImperial,
                            selection: metric
                        )
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 18)

            }
            
            // Refetch hourly data whenever the selected city changes
            .task(id: selectionManager.selectedRecord) {
                if let record = selectionManager.selectedRecord {
                    await weatherAPI.currentForecast(
                        latitude: record.latitude,
                        longitude: record.longitude
                    )
                }
            }
        }

    }
}

//  gives list of example points for the chart
enum Metric: Int, CaseIterable {
    case temp = 1
    case precip, humidity, wind

    var title: String {
        switch self {
        case .temp: return "Temp"
        case .precip: return "Precipitation"
        case .humidity: return "Humidity"
        case .wind: return "Wind"
        }
    }
}

// Date formatters for time conversion
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"  // Format from Open-Meteo API
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
// Formats the time as hour label, "3 PM"
private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h a"
    return formatter
}()
// Converts ISO timestamp string to short time string
func formatTime(_ isoTime: String) -> String {
    if let date = dateFormatter.date(from: isoTime) {
        return timeFormatter.string(from: date)
    }
    return isoTime  // Fallback
}

private func series(
    for metric: Metric,
    record: WeatherRecord,
    useImperial: Bool
) -> [HourlyPt] {
    let count = min(record.time.count, 24)  // Limit to the first 24 hours

    // Check if there is enough data
    guard count > 1 else { return [] }

    
    // Helps given an array of raw values, build HourlyPt with normalized y values
    func createSeries(data: [Double], unit: String, isPercentage: Bool = false)
        -> [HourlyPt]
    {
        let values = data.prefix(count)
        guard let minVal = values.min(), let maxVal = values.max() else {
            return []
        }

        // If the max and min are the same, the range is 0
        let range = maxVal - minVal
        let safeRange = (range == 0 || range.isNaN) ? 1.0 : range

        return zip(record.time.prefix(count), values).map { (time, value) in
            let label =
                isPercentage ? "\(Int(value))\(unit)" : "\(Int(value)) \(unit)"
            
            //normalize y into 0...1 so chart can scale it to the geometry height
            var normalizedY: Double
            if isPercentage {
                normalizedY = value / 100.0 //0–1 range for 0–100%
            } else {
                // Avoid a completely flat line at 0 so points still appear
                normalizedY = (value - minVal) / safeRange
                normalizedY = max(0.1, normalizedY)
            }

            return .init(
                t: formatTime(time), //"3pm"
                y: normalizedY,
                label: label
            )
        }
    }
    // Per-metric unit conversions
    func celsiusToFahrenheit(_ c: [Double]) -> [Double] {
        return c.map { $0 * 9.0 / 5.0 + 32.0 }
    }

    func kmhToMph(_ k: [Double]) -> [Double] {
        return k.map { $0 * 0.621371 }
    }

    switch metric {
    case .temp:
        return !useImperial
            ? createSeries(data: record.temperature, unit: "°")
            : createSeries(
                data: celsiusToFahrenheit(record.temperature),
                unit: "°"
            )
    case .precip:
        return createSeries(
            data: record.precipitationProb,
            unit: "%",
            isPercentage: true
        )
    case .humidity:
        return createSeries(
            data: record.humidity,
            unit: "%",
            isPercentage: true
        )
    case .wind:
        return !useImperial
            ? createSeries(data: record.windSpeed, unit: "kmh")
            : createSeries(data: kmhToMph(record.windSpeed), unit: "mph")
    }
}

private func color(for metric: Metric) -> Color {
    switch metric {
    case .temp: return .blue
    case .precip: return .teal
    case .humidity: return .indigo
    case .wind: return .purple
    }
}

#Preview {
    let manager = AppSelectionManager()
    // (Optional) You could also set a fake selection here if you want:
    // manager.selectedRecord = GeolocationRecord(
    //     id: "preview",
    //     name: "Houston",
    //     latitude: 29.76,
    //     longitude: -95.37,
    //     country: "US",
    //     admin1: "Texas"
    // )

    return NavigationStack {
        HourlyDetailView(cityName: "Houston, TX")
            .environmentObject(manager)
    }
}
