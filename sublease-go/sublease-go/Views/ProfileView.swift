import SwiftUI

struct ProfileView: View {
    let uwEmail: String
    @Binding var listings: [Listing]
    @EnvironmentObject var auth: AuthManager
    private let listingsService = FirebaseListingsService()

    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    private var myListings: [Listing] {
        listings.filter { $0.userId == auth.userId }
    }

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 12) {
                        Text("Profile")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(uwPurple)

                        ZStack {
                            Circle()
                                .fill(textBox)
                                .frame(width: 100, height: 100)

                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(uwPurple)
                        }

                        VStack(alignment: .center, spacing: 6) {
                            Text("UW Verified")
                                .font(.headline)
                                .foregroundStyle(textPrimary)

                            Text(auth.uwEmail)
                                .foregroundStyle(textMuted)
                        }
                        .card()

                        VStack(alignment: .center, spacing: 8) {
                            Text("My Listings")
                                .font(.headline)
                                .foregroundStyle(textPrimary)

                            if myListings.isEmpty {
                                Text("No listings yet")
                                    .foregroundStyle(textMuted)
                            } else {
                                ForEach(myListings) { listing in
                                    VStack(spacing: 8) {
                                        ListingCard(listing: listing)

                                        Button(role: .destructive) {
                                            Task {
                                                await deleteListing(listing)
                                            }
                                        } label: {
                                            Text("Delete listing")
                                                .frame(maxWidth: .infinity)
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                                .foregroundStyle(textPrimary)
                            }
                        }
                        .card()

                        Spacer()

                        Button {
                            auth.signOut()
                        } label: {
                            HStack(spacing: 8) {
                                Text("SIGN OUT")
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
                .background(background)
            }
        }
    }

    @MainActor
    private func deleteListing(_ listing: Listing) async {
        do {
            try await listingsService.deleteListing(id: listing.id)
            listings.removeAll { $0.id == listing.id }
        } catch {
            print("Failed to delete listing: \(error)")
        }
    }
}
