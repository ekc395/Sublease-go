import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var emailInput = ""
    @State private var passwordInput = ""
    @State private var error: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Sublease-go")
                .font(.largeTitle)
                .bold()

            Text("Enter your UW email and password. If your account does not exist yet, it will be created automatically.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            TextField("yourname@uw.edu", text: $emailInput)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            SecureField("Password", text: $passwordInput)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                error = nil
                isLoading = true

                Task {
                    do {
                        try await auth.loginOrCreate(email: emailInput, password: passwordInput)
                        await MainActor.run {
                            isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            self.error = error.localizedDescription
                            self.isLoading = false
                        }
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            if let error {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
