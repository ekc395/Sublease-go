//
//  LoginView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

// NOTE TO SELF: improve login page for better modern aesthetics (more button to typing in to login workflow)
import SwiftUI

struct LoginView: View {
    @Binding var uwEmail: String
    @Binding var isAuthed: Bool
    @State private var error: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Spacer().frame(height: 20)

                Text("Sublease-go")
                    .font(.largeTitle.weight(.semibold))

                Text("UW-only subleases. Verify your @uw.edu email to continue.")
                    .foregroundStyle(.secondary)

                TextField("yourname@uw.edu", text: $uwEmail)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Button {
                    let email = uwEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    guard email.hasSuffix("@uw.edu") else {
                        error = "Please use a @uw.edu email."
                        return
                    }
                    error = nil
                    withAnimation(.spring()) { isAuthed = true }
                } label: {
                    Text("Continue").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)

                if let error {
                    Text(error).foregroundStyle(.red).font(.footnote)
                }

                Spacer()

            }
            .padding(20)
        }
    }
}
