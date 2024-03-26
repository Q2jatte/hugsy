//
//  HugsyApp.swift
//  Hugsy
//
//  Created by Eric Terrisson on 26/03/2024.
//

import SwiftUI

@main
struct HugsyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
