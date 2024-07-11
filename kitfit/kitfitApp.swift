//
//  kitfitApp.swift
//  kitfit
//
//  Created by 신병기 on 6/19/24.
//

import SwiftUI

@main
struct kitfitApp: App {
    @StateObject private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
    }
}
