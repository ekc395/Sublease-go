//
//  sublease_goApp.swift
//  sublease-go
//
//  Created by Ethan Chen on 3/3/26.
//

import SwiftUI
import FirebaseCore

@main
struct sublease_goApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
