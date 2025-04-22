//
//  CurrencyTrackerApp.swift
//  CurrencyTracker
//
//  Created by Matthew Castaneda on 4/8/25.
//

import SwiftUI
import SwiftData

@main
struct CurrencyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: trackedSymbols.self)
    }
}
