import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var isAuthed = false
    @Published private(set) var userId = ""
    @Published private(set) var uwEmail = ""

    private let db = Firestore.firestore()

    init() {
        restore()
    }

    func restore() {
        if let user = Auth.auth().currentUser {
            userId = user.uid
            uwEmail = user.email ?? ""
            isAuthed = true
        } else {
            userId = ""
            uwEmail = ""
            isAuthed = false
        }
    }

    func loginOrCreate(email: String, password: String) async throws {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard normalized.hasSuffix("@uw.edu") else {
            throw NSError(
                domain: "",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Please use a valid @uw.edu email."]
            )
        }

        guard !trimmedPassword.isEmpty else {
            throw NSError(
                domain: "",
                code: 402,
                userInfo: [NSLocalizedDescriptionKey: "Please enter your password."]
            )
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: normalized, password: trimmedPassword)

            await MainActor.run {
                self.userId = result.user.uid
                self.uwEmail = result.user.email ?? normalized
                self.isAuthed = true
            }
        } catch {
            guard let nsError = error as NSError?,
                  let authCode = AuthErrorCode(rawValue: nsError.code) else {
                throw error
            }

            switch authCode {
            case .userNotFound, .invalidCredential:
                let result = try await Auth.auth().createUser(withEmail: normalized, password: trimmedPassword)
                let uid = result.user.uid

                let data: [String: Any] = [
                    "email": normalized,
                    "createdAt": Timestamp(date: Date())
                ]

                try await db.collection("users").document(uid).setData(data, merge: true)

                await MainActor.run {
                    self.userId = uid
                    self.uwEmail = normalized
                    self.isAuthed = true
                }

            case .wrongPassword:
                throw NSError(
                    domain: "",
                    code: 403,
                    userInfo: [NSLocalizedDescriptionKey: "Incorrect password."]
                )

            case .emailAlreadyInUse:
                throw NSError(
                    domain: "",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "This account already exists. Try a different password."]
                )

            case .weakPassword:
                throw NSError(
                    domain: "",
                    code: 405,
                    userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters."]
                )

            case .invalidEmail:
                throw NSError(
                    domain: "",
                    code: 406,
                    userInfo: [NSLocalizedDescriptionKey: "Please enter a valid email address."]
                )

            default:
                throw error
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        userId = ""
        uwEmail = ""
        isAuthed = false
    }
}
