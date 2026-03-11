//
//  MainTabView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI
import FirebaseFirestore

struct MainTabView: View {
    let uwEmail: String
    @Binding var listings: [Listing]
    @Binding var filters: Filters
    @Binding var threads: [Thread]

    private let listingsService = FirebaseListingsService()
    private let messagingService = FirebaseMessagingService()

    @State private var hasLoadedListings = false
    @State private var threadListener: ListenerRegistration?
    @State private var selectedTab = 0

    private var currentUserId: String { uwEmail }
    private var currentUserName: String { uwEmail }
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    var body: some View {
        ZStack {
            
            TabView(selection: $selectedTab) {
                ListingFeedView(
                    currentUserId: currentUserId,
                    currentUserName: currentUserName,
                    listings: $listings,
                    filters: $filters,
                    threads: $threads,
                    onRefresh: {
                        Task { await refreshListings() }
                    }
                )
                .tabItem {
                    Label("Feed", systemImage: "square.grid.2x2")
                }

                CreateListingView(
                    listings: $listings,
                    selectedTab: $selectedTab,
                    onPosted: {
                        Task { await refreshListings() }
                    },
                    userId: currentUserId,
                    ownerName: currentUserName
                )
                .tabItem {
                    Label("Post", systemImage: "plus.circle")
                }

                MessagesView(
                    currentUserId: currentUserId,
                    threads: $threads
                )
                .tabItem {
                    Label("Messages", systemImage: "message")
                }

                ProfileView(uwEmail: uwEmail, listings: listings)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .foregroundStyle(textPrimary)
            .tint(uwPurple)
            .task {
                await loadListingsIfNeeded()
                startThreadsListener()
            }
            .onDisappear {
                threadListener?.remove()
                threadListener = nil
            }
            .background(background)
        }
        
    }

    private func startThreadsListener() {
        threadListener?.remove()

        threadListener = messagingService.listenForThreads(currentUserId: currentUserId) { newThreads in
            self.threads = newThreads
        }
    }

    @MainActor
    private func loadListingsIfNeeded() async {
        guard !hasLoadedListings else { return }
        hasLoadedListings = true

        do {
            listings = try await listingsService.fetchListings()
        } catch {
            print("Failed to load listings from Firestore: \(error)")
        }
    }
    
    @MainActor
    private func refreshListings() async {
        do {
            listings = try await listingsService.fetchListings()
        } catch {
            print("Failed to refresh listings from Firestore: \(error)")
        }
    }
}
