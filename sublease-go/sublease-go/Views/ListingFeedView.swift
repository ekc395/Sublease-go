//
//  ListingFeedView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ListingFeedView: View {
    let currentUserId: String
    let currentUserName: String
    @Binding var listings: [Listing]
    @Binding var filters: Filters
    @Binding var threads: [Thread]
    let onRefresh: () -> Void

    @State private var showFilters = false
    @State private var selectedListing: Listing? = nil
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    private var filteredListings: [Listing] {
        filters.apply(to: listings)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    Text("Listing Feed")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(uwPurple)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredListings) { listing in
                                ListingCard(listing: listing)
                                    .onTapGesture { selectedListing = listing }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {

                    Button {
                        onRefresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(uwPurple)
                    }

                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(uwPurple)
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filters: $filters)
            }
            .sheet(item: $selectedListing) { listing in
                ListingDetailView(
                    listing: listing,
                    currentUserId: currentUserId,
                    currentUserName: currentUserName,
                    threads: $threads
                )
            }
        }
    }
}
