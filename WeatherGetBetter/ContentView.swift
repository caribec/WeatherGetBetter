//
//  ContentView.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    //Text("Home")
                }
            HourlyDetailView()
                .tabItem {
                    Image(systemName: "clock")
                    //Text("Hourly Detail")
                }
            DailyDetailView()
                .tabItem {
                Image(systemName: "calendar")
            }
            
        }
        .tabViewStyle(.automatic)
    }
}

#Preview {
    ContentView()
}
