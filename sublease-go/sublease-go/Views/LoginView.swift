//
//  LoginView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var emailInput = ""
    @State private var passwordInput = ""
    @State private var error: String?
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer().frame(height: 20)

                    Text("Sublease-\(Text("go").foregroundStyle(uwGold))")
                        .font(.system(size: 43, weight: .semibold, design: .serif))
                        .foregroundStyle(uwPurple)

                    Text("UW-ONLY SUBLEASES. ENTER YOUR @UW.EDU EMAIL AND PASSWORD TO CONTINUE.")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(textMuted)
                        .tracking(1.6)
                    
                    VStack(spacing: 12) {
                        TextField("yourname@uw.edu", text: $emailInput)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding(13)
                            .background(textBox)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        
                        // password field and db things for it later
                        SecureField("Password", text: $passwordInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(13)
                                .background(textBox)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }


                    Button {
                        let email = emailInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
              
                        if (email.hasSuffix("@uw.edu") || !passwordInput.isEmpty) {
                            error = nil
                            auth.login(email: email)
                        } else {
                            error = "Please use an @uw.edu email or enter your password."
                        }
                        
                    } label: {
                        HStack(spacing: 8) {
                            Text("CONTINUE")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(uwPurple)
                        )
                    }

                    if let error {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }

                    Spacer()

                }
                .padding(20)
                .padding(.horizontal, 18)
                .background(background)
            }
        }
        
    }
}
