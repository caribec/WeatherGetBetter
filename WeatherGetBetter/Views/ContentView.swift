//
//  ContentView.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//
import SwiftUI

struct ContentView: View {
   // ✔ Read them
   // ✔ Update them
   //✔ React live to changes
    @EnvironmentObject var favorites: FavoritesStore
    @EnvironmentObject var selectionManager: AppSelectionManager

    init() {
        // Customize Tab Bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectionManager.activeTab) {
            //Home tab
            NavigationStack {
                HomeView()
            }
            .tabItem { Image(systemName: "house") }
            .tag(0)

            NavigationStack {
                if let record = selectionManager.selectedRecord {
                    HourlyDetailView(cityName: record.fullLocationName)
                } else {
                    Text("No city selected")
                        .italic()
                        .foregroundColor(.gray)
                }
            }
            .tabItem { Image(systemName: "clock") }
            .tag(1)

            // 7-DAY FORECAST TAB
            NavigationStack {
                if let record = selectionManager.selectedRecord {
                    DailyDetailView(
                        cityName: record.fullLocationName,
                        latitude: record.latitude,
                        longitude: record.longitude
                    )
                } else {
                    Text("No city selected")
                        .italic()
                        .foregroundColor(.gray)
                }
            }

            .tabItem { Image(systemName: "calendar") }
            .tag(2)
            //fav tab
            NavigationStack {
                FavoritesView()
            }
            .tabItem { Image(systemName: "heart") }
            .tag(3)
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
        .environmentObject(AppSelectionManager())
}
