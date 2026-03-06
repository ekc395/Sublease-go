//
//  ContentView.swift
//  sublease-go
//
//  Created by Ethan Chen on 3/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthed = false
    @State private var uwEmail = ""

    @State private var listings: [Listing] = []
    @State private var filters = Filters()
    @State private var threads: [Thread] = Thread.mock

    var body: some View {
        Group {
            if isAuthed {
                MainTabView(
                    uwEmail: uwEmail,
                    listings: $listings,
                    filters: $filters,
                    threads: $threads
                )
            } else {
                LoginView(uwEmail: $uwEmail, isAuthed: $isAuthed)
            }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
}
