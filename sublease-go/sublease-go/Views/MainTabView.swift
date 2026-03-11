//
//  MainTabView.swift
//  sublease-go
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

    @EnvironmentObject var auth: AuthManager

    private var currentUserId: String { auth.userId }
    private var currentUserName: String { auth.uwEmail }

    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)

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
                .tag(0)

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
                .tag(1)

                MessagesView(
                    currentUserId: currentUserId,
                    threads: $threads
                )
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .tag(2)

                ProfileView(uwEmail: uwEmail, listings: $listings)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
            .tint(uwPurple)
            .background(background)
            .task {
                await loadListingsIfNeeded()
                startThreadsListener()
            }
            .onDisappear {
                threadListener?.remove()
                threadListener = nil
            }
        }
    }

    private func startThreadsListener() {
        guard !currentUserId.isEmpty else { return }

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
