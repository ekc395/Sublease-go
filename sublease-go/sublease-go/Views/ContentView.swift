//
//  ContentView.swift
//  sublease-go
//
//  Created by Ethan Chen on 3/3/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var showingLogin = false
    @State private var finishProfileSetup = false
    @State private var showProfile = false
    @State private var displayName = ""
    @State private var bio = ""
    @State private var listings: [Listing] = []
    @State private var filters = Filters()
    @State private var threads: [Thread] = Thread.mock

    var body: some View {
        Group {
            if (finishProfileSetup) {
                MainTabView(
                    uwEmail: auth.uwEmail,
                    listings: $listings,
                    filters: $filters,
                    threads: $threads
                )
            } else if (showProfile) {
                ProfileSetupView(
                    displayName: $displayName,
                    bio: $bio,
                    finishedProfileSetup: $finishProfileSetup
                )
            } else if (showingLogin) {
                LoginView(showProfile: $showProfile)
            } else {
                HomeView(onStart: {
                    showingLogin = true
                })
            }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager.shared)
}
