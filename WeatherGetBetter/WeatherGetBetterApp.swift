//
//  WeatherGetBetterApp.swift
//  WeatherGetBetter
//
//  Created by Carissa Becerra on 10/27/25.
//

import SwiftUI

@main
struct WeatherGetBetterApp: App {
    
    //stores favorited locations
    @StateObject private var favorites = FavoritesStore()
    // manages which city is selected & which tab is active
    @StateObject private var selectionManager = AppSelectionManager()

    var body: some Scene {
        WindowGroup {
            // first screen the user sees
            StartupView()
                //make these shared objects available to all views in the app
                //any child view of startup can access favorites
                .environmentObject(favorites)
                .environmentObject(selectionManager)
        }
    }
}
