//
//  kitfitApp.swift
//  kitfit
//
//  Created by 신병기 on 6/19/24.
//

import SwiftUI
import SwiftData

@main
struct kitfitApp: App {
    @StateObject private var appData = AppData()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Kit.self, KitSize.self)
            
            // 샘플 데이터 추가
            let context = container.mainContext
            SampleDataManager.addSampleData(to: context)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
        .modelContainer(container)
    }
}
