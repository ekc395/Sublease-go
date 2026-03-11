//
//  CreateListingView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct CreateListingView: View {
    @Binding var listings: [Listing]
    @Binding var selectedTab: Int
    let onPosted: () -> Void
    var userId: String = ""
    var ownerName: String = ""

    private let listingsService = FirebaseListingsService()

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var bedrooms = 1
    @State private var apartmentBuilding = ""
    @State private var furnished = false
    @State private var error: String?
    @State private var isPosting = false
    @FocusState private var isFieldFocused: Bool
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    var body: some View {
        NavigationStack {
            ZStack {
                background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text("Create")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(uwPurple)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Form {
                        Section("Listing") {
                            TextField("Title", text: $title)
                                .focused($isFieldFocused)
                            TextField("Apartment / Building", text: $apartmentBuilding)
                                .textInputAutocapitalization(.words)
                                .focused($isFieldFocused)
                            TextField("Monthly price", text: $price)
                                .keyboardType(.numberPad)
                                .focused($isFieldFocused)
                            Stepper("Bedrooms: \(bedrooms)", value: $bedrooms, in: 1...10)
                            Toggle("Furnished", isOn: $furnished)
                        }
                        .foregroundStyle(textPrimary)

                        Section("Description") {
                            TextEditor(text: $description)
                                .frame(minHeight: 120)
                                .focused($isFieldFocused)
                        }
                        .foregroundStyle(textPrimary)

                        Section {
                            Button {
                                isFieldFocused = false
                                
                                guard let p = Int(price), p > 0 else {
                                    error = "Enter a valid price."
                                    return
                                }

                                guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                    error = "Title is required."
                                    return
                                }

                                error = nil
                                isPosting = true

                                let now = Date()
                                let defaultEnd = Calendar.current.date(byAdding: .month, value: 3, to: now) ?? now
                                let building = apartmentBuilding.isEmpty ? "Seattle" : apartmentBuilding
                                let desc = description.isEmpty ? "No description yet." : description
                                let displayOwnerName = ownerName.isEmpty ? userId : ownerName

                                Task {
                                    do {
                                        let docId = try await listingsService.createListing(
                                            title: title,
                                            description: desc,
                                            price: p,
                                            bedrooms: bedrooms,
                                            apartmentBuilding: building,
                                            furnished: furnished,
                                            genderPreference: "Any",
                                            schoolYearPreference: "Any",
                                            leaseStart: now,
                                            leaseEnd: defaultEnd,
                                            userId: userId,
                                            ownerName: displayOwnerName
                                        )

                                        await MainActor.run {
                                            let new = Listing(
                                                id: docId,
                                                title: title,
                                                price: p,
                                                bedrooms: bedrooms,
                                                apartmentBuilding: building,
                                                furnished: furnished,
                                                description: desc,
                                                genderPreference: "Any",
                                                leaseStart: now,
                                                leaseEnd: defaultEnd,
                                                schoolYearPreference: "Any",
                                                userId: userId,
                                                ownerName: displayOwnerName
                                            )

                                            listings.insert(new, at: 0)
                                            title = ""
                                            description = ""
                                            price = ""
                                            bedrooms = 1
                                            apartmentBuilding = ""
                                            furnished = false
                                            isPosting = false
                                            
                                            onPosted()
                                            isFieldFocused = false
                                            selectedTab = 0
                                        }
                                    } catch let err {
                                        await MainActor.run {
                                            error = "Failed to post: \(err.localizedDescription)"
                                            isPosting = false
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(isPosting ? "Posting…" : "POST LISTING")
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
                            .disabled(isPosting)
                        }
                        .listRowBackground(Color.clear)

                        if let error {
                            Section {
                                Text(error)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                selectedTab = 0
                            }
                            .foregroundStyle(uwPurple)
                        }
                    }
                }
            }
        }
    }
}
