//
//  ListingDetailView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ListingDetailView: View {
    let listing: Listing
    let currentUserId: String
    let currentUserName: String
    @Binding var threads: [Thread]

    @Environment(\.dismiss) private var dismiss
    @State private var pushToThread: Thread? = nil

    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)
    
    private let messagingService = FirebaseMessagingService()

    var body: some View {
        NavigationStack {
            ZStack {
                background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .center, spacing: 18) {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(textBox)
                            .frame(height: 220)
                            .overlay(
                                Text("Photos")
                                    .foregroundStyle(textMuted)
                            )

                        VStack(alignment: .leading, spacing: 10) {
                            Text(listing.title)
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(textPrimary)

                            HStack(spacing: 8) {
                                Pill("$\(listing.price)/mo")
                                Pill("\(listing.bedrooms) BR")
                                Pill(listing.apartmentBuilding)
                            }

                            Text(listing.description)
                                .foregroundStyle(textMuted)
                        }
                        .card()

                        Button {
                            Task {
                                do {
                                    let threadId = try await messagingService.createOrGetThread(
                                        listingId: listing.id,
                                        listingTitle: listing.title,
                                        currentUserId: currentUserId,
                                        currentUserName: currentUserName,
                                        otherUserId: listing.userId,
                                        otherUserName: listing.ownerName
                                    )

                                    await MainActor.run {
                                        if let existing = threads.first(where: { $0.id == threadId }) {
                                            pushToThread = existing
                                        } else {
                                            let new = Thread(
                                                id: threadId,
                                                listingId: listing.id,
                                                otherName: listing.ownerName,
                                                lastPreview: "",
                                                updatedAt: Date(),
                                                messages: []
                                            )
                                            threads.insert(new, at: 0)
                                            pushToThread = new
                                        }
                                    }
                                } catch {
                                    print("Failed to create/get thread:", error.localizedDescription)
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("MESSAGE LISTER")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(background)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(uwPurple)
                            )
                        }
                    }
                    .padding(16)
                }
                .padding(4)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Listing Details")
                        .font(.headline)
                        .foregroundStyle(uwPurple)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(item: $pushToThread) { thread in
                ChatThreadView(
                    threadId: thread.id,
                    currentUserId: currentUserId,
                    threads: $threads
                )
            }
        }
    }
}
