//
//  HomeScreenView.swift
//  WeatherGetBetter
//
//  Created by Alejandro Galvez on 10/28/25.
//

import SwiftUI

struct HomeView: View {
    @State private var searchString: String = ""
    
    var body: some View {
        VStack() {
            Text("WeatherGetBetter")
            //TextField($searchString)
        }
    }
}

#Preview {
    HomeView()
}
