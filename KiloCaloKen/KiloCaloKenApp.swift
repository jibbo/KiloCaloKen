//
//  KiloCaloKenApp.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 07/08/24.
//

import SwiftUI
import SwiftData

@main
struct KiloCaloKenApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HomeViewModel(modelContext: container.mainContext))
                .modelContainer(container)
        }
    }
    
    init() {
        do {
            container = try ModelContainer(for: LocalProduct.self)
        } catch {
            fatalError("Failed to create ModelContainer for UserModel.")
        }
    }
}
