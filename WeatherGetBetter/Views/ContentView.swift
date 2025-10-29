//
//  ContentView.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }

                HourlyDetailView()
                    .tabItem {
                        Image(systemName: "clock")
                    }

                DailyDetailView()
                    .tabItem {
                        Image(systemName: "calendar")
                    }
            }
            .tabViewStyle(.automatic)
        }
    }
}

#Preview {
    ContentView()
}
