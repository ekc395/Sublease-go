//
//  ProfileSetUpView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/6/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @Binding var displayName: String
    @Binding var bio: String
    @Binding var finishedProfileSetup: Bool

    @State private var error: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Spacer().frame(height: 20)

                Text("Set up your profile")
                    .font(.largeTitle.weight(.semibold))

                Text("Add a display name and short bio.")
                    .foregroundStyle(.secondary)

                TextField("Display name", text: $displayName)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                TextEditor(text: $bio)
                    .frame(height: 120)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if let error {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                Spacer()

                Button {
                    let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        error = "Please enter a display name."
                        return
                    }
                    error = nil
                    finishedProfileSetup = true
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .padding(20)
        }
    }
}
