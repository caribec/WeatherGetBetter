//
//  ContentView.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/28/25.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        //Modify tab bar so it is more visible
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                EmptyHomeView()
                    .tabItem {
                        Image(systemName: "house")
                            .foregroundStyle(Color.black)
                            .padding()
                    }

                HourlyDetailView()
                    .tabItem {
                        Image(systemName: "clock")
                            .padding()
                    }

                DailyDetailView()
                    .tabItem {
                        Image(systemName: "calendar")
                            .padding()
                    }
            }
            .tabViewStyle(.automatic)
            .tint(.black)
        }
    }
}

#Preview {
    ContentView()
}
