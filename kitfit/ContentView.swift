//
//  ContentView.swift
//  kitfit
//
//  Created by 신병기 on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                HomeView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                
                HomeView()
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Notification")
                    }
                
                UniformListView(viewModel: appData.uniformViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            
            if !appData.isSplashFinished {
                SplashScreen()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
