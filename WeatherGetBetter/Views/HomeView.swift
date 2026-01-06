//
//  HomeView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import Combine
import SwiftUI

//extension used to allow deselection by tapping away
#if canImport(UIKit)
    extension View {
        func hideKeyboard() {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
#endif

final class AppSelectionManager: ObservableObject {
    //determines which city is currently displayed
    @Published var selectedRecord: GeolocationRecord? = nil

    //current tab
    @Published var activeTab: Int = 0
}

struct SearchTextField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.red)

            TextField("Search City Here", text: $text)
                .foregroundColor(.primary)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)

            Spacer()

            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// One row in the location search results list
struct locationCell: View {
    var record: GeolocationRecord // City to display in the row
    @ObservedObject var favorites: FavoritesStore  // Store that knows all favorite cities
    @Binding var searchString: String
    @EnvironmentObject var selectionManager: AppSelectionManager  // Shared app selection state
    var onFavoriteChange: (Bool, String) -> Void

    var onSelected: (() -> Void)? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                let cityName: String =
                    "\(record.name), \(record.admin1), \(record.country)"
                Text(cityName)
                    .font(.body)
                    .bold()
                Text("\(record.latitude) \(record.longitude)")
                    .font(.caption)
                    .fontWeight(.light)
            }
            Spacer()
            Button(action: {
                let added = favorites.toggle(record)
                onFavoriteChange(added, record.name)
            }) {
                Image(
                    systemName: favorites.contains(record)
                        ? "heart.fill" : "heart"
                )
            }
            .foregroundStyle(.pink)
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle())  // make whole row tappable
        .onTapGesture {
            searchString = ""
            selectionManager.selectedRecord = record
            onSelected?()  // triggers the StartupView navigation
        }

    }
}

//shows a city title + glance panel + lifestyle tip
struct CityWeatherHomeView: View {
    // The selected city
    var record: GeolocationRecord
    // The weather data for that city
    var forecast: WeatherRecord

    @AppStorage("useImperial") private var useImperial: Bool = true

    var body: some View {
        Text("\(record.name), \(record.admin1)")
            .font(.title)
            .fontWeight(.bold)

        // Glance panel will use `useImperial`
        GlancePanelView(weatherForecast: forecast)
            .padding()

        let tip = WeatherTextHelpers.lifestyleTip(
            for: forecast,
            isFahrenheit: useImperial
        )

        Text(tip)
            .italic()
            .multilineTextAlignment(.center)
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Palette.accentPrimaryBackground.opacity(0.9),
                        Palette.accentSecondaryBackground.opacity(0.9),
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
            .frame(maxWidth: 300)
    }
}
//shows title, toolbar, and today’s weather
struct HomeView: View {
    
    //Shows a temporary “added/removed from favorites”
    func triggerFavoriteMessage(added: Bool, city: String) {
        statusMessage =
            added
            ? "You've added \(city) to favorites"
            : "You've removed \(city) from favorites"

        withAnimation {
            showStatusMessage = true
        }
        // Auto-hide the message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showStatusMessage = false
            }
        }
    }
    // Loads weather for the currently selected city
    func loadWeatherForCurrentSelection() async {
        // If nothing is selected, does not call the API
        guard let record = selectionManager.selectedRecord else { return }
        await weatherAPI.loadRecords(
            latitude: record.latitude,
            longitude: record.longitude
        )
        self.weatherForecast = weatherAPI.record
    }
    private func dismissSearch() {
        hideKeyboard()
        isSearchFieldFocused = false
        withAnimation {
            isSearching = false  // go back to round button
        }
        searchString = ""  // clear text
        locationAPI.eraseRecords()  // clear suggestions
    }

    // Heart button in the top toolbar
    private var favoriteToolbarButton: some View {
        Button {
            // Only act if a city is selected
            guard let record = selectionManager.selectedRecord else { return }

            let added = favorites.toggle(record)
            triggerFavoriteMessage(added: added, city: record.name)
        } label: {
            let isFav =
                selectionManager.selectedRecord.flatMap {
                    favorites.contains($0)
                } ?? false

            Image(systemName: isFav ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isFav ? .red : .gray)
                .padding(12)
                .background(
                    LinearGradient(
                        colors: [
                            Palette.accentPrimaryBackground.opacity(0.9),
                            Palette.accentSecondaryBackground.opacity(0.9),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.black.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
                )

        }
        .buttonStyle(.plain)

    }

    @StateObject private var locationAPI = GeolocationAPI()
    @StateObject private var weatherAPI = WeatherAPI()
    
    // Shared state from parent
    @EnvironmentObject var favorites: FavoritesStore
    @EnvironmentObject var selectionManager: AppSelectionManager

    @State private var searchString: String = ""
    @State private var showingFavorites = false
    @State private var isSearching: Bool = false
    @FocusState private var isSearchFieldFocused: Bool

    // Latest weather for the selected city
    @State private var weatherForecast: WeatherRecord? = nil

    //"added to fav" message
    @State private var statusMessage: String = ""
    @State private var showStatusMessage: Bool = false

    var cityName: String {
        guard let record = selectionManager.selectedRecord else { return "" }
        return "\(record.name), \(record.admin1), \(record.country)"
    }
    //Whether to show the search suggestions overlay below the toolbar
    var isSearchResultsVisible: Bool {
        return !searchString.isEmpty && !locationAPI.records.isEmpty
    }

    fileprivate func SearchResultsList() -> some View {
        return VStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(locationAPI.records, id: \.id) { record in
                            locationCell(
                                record: record,
                                favorites: favorites,
                                searchString: $searchString,
                                onFavoriteChange: { added, city in
                                    triggerFavoriteMessage(
                                        added: added,
                                        city: city
                                    )
                                },
                                onSelected: {
                                    dismissSearch()
                                }
                            )
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            Divider()
                                .padding(.leading)
                        }

                    }
                }
                .frame(maxHeight: 400)
            }
            .background(Color(.systemBackground))
            .cornerRadius(18)
            .shadow(radius: 10)
            .padding(.horizontal, 18)

            Spacer()
        }
        .padding(.top, 150)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    var body: some View {
        ZStack {

            AppBackground()
                .ignoresSafeArea()

            VStack(spacing: 8) {

                // Fixed top spacing / safe area
                Spacer().frame(height: 12)

                Text("WeatherGetBetter")
                    .font(.custom("Helvetica Neue", size: 35))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)

                ScrollView {
                    VStack(spacing: 12) {

                        // Status message
                        if showStatusMessage {
                            Text(statusMessage)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(Color(.systemBackground))
                                        .shadow(radius: 4)
                                )
                                .transition(
                                    .move(edge: .top).combined(with: .opacity)
                                )
                                .animation(
                                    .easeInOut(duration: 0.25),
                                    value: showStatusMessage
                                )
                        }

                        HStack(spacing: 12) {
                            Spacer()

                            if isSearching {

                                SearchTextField(text: $searchString)
                                    .focused($isSearchFieldFocused)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(
                                                Color(.systemBackground)
                                                    .opacity(0.9)
                                            )
                                            .overlay(
                                                RoundedRectangle(
                                                    cornerRadius: 22
                                                )
                                                .stroke(
                                                    .black.opacity(0.15),
                                                    lineWidth: 1
                                                )
                                            )
                                            .shadow(
                                                color: .black.opacity(0.2),
                                                radius: 6,
                                                y: 4
                                            )
                                    )
                                    .onAppear {
                                        DispatchQueue.main.async {
                                            isSearchFieldFocused = true
                                        }
                                    }

                                Button("Cancel") {
                                    withAnimation {
                                        hideKeyboard()
                                        isSearchFieldFocused = false
                                        searchString = ""
                                        locationAPI.eraseRecords()
                                        isSearching = false
                                    }
                                }
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .padding(.trailing, 18)

                            } else {

                                Button {
                                    withAnimation {
                                        isSearching = true
                                    }
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                        .padding(12)
                                        .background(
                                            LinearGradient(
                                                colors: [
                                                    Palette
                                                        .accentPrimaryBackground
                                                        .opacity(0.9),
                                                    Palette
                                                        .accentSecondaryBackground
                                                        .opacity(0.9),
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(
                                                    .black.opacity(0.25),
                                                    lineWidth: 1
                                                )
                                            )
                                            .shadow(
                                                color: .black.opacity(0.25),
                                                radius: 6,
                                                y: 4
                                            )
                                        )
                                }
                                .buttonStyle(.plain)

                                favoriteToolbarButton

                                NavigationLink(destination: SettingsView()) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                        .padding(12)
                                        .background(
                                            LinearGradient(
                                                colors: [
                                                    Palette
                                                        .accentPrimaryBackground
                                                        .opacity(0.9),
                                                    Palette
                                                        .accentSecondaryBackground
                                                        .opacity(0.9),
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(
                                                    .black.opacity(0.25),
                                                    lineWidth: 1
                                                )
                                            )
                                            .shadow(
                                                color: .black.opacity(0.25),
                                                radius: 6,
                                                y: 4
                                            )
                                        )
                                }
                                .padding(.trailing, 18)
                            }
                        }

                        VStack(spacing: 20) {
                            Group {
                                if selectionManager.selectedRecord == nil {
                                    EmptyView()
                                } else if weatherAPI.isLoading
                                    || weatherForecast == nil
                                {
                                    LoadingView()
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .center
                                        )
                                        .padding(.top, 50)
                                } else {
                                    CityWeatherHomeView(
                                        record: selectionManager
                                            .selectedRecord!,
                                        forecast: weatherForecast!
                                    )
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                            searchString = ""
                            withAnimation {
                                isSearching = false
                            }
                            locationAPI.eraseRecords()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
                // Initial fetch for search suggestions
                .task {
                    await locationAPI.loadRecords(search: searchString)
                }
                // Refetch suggestions whenever the text changes
                .onChange(of: searchString) {
                    Task { await locationAPI.loadRecords(search: searchString) }
                }
                // Load weather when the view first appears
                .task {
                    await loadWeatherForCurrentSelection()
                }
                //Reload weather when the user selects a different city
                .onChange(of: selectionManager.selectedRecord) { _, _ in
                    Task { await loadWeatherForCurrentSelection() }
                }
            }
            
            //suggestion list above everything when searching
            if isSearchResultsVisible {
                SearchResultsList()
            }
        }
    }

}
//loading
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
            Text("Fetching Weather Data...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(50)
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {

    NavigationStack {
        HomeView()
            .environmentObject(FavoritesStore())
            .environmentObject(AppSelectionManager())
    }
}
