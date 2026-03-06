//
//  HomeView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/5/26.
//

import SwiftUI

struct HomeView: View {
    let onStart: () -> Void
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer().frame(height: 20)
                    
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(uwGold)
                            .frame(width: 28, height: 2)
                        Circle()
                            .fill(uwGold)
                            .frame(width: 5, height: 5)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Text("Sublease-\(Text("go").foregroundStyle(uwGold))")
                        .font(.system(size: 58, weight: .semibold, design: .serif))
                        .foregroundStyle(uwPurple)
                    
                    Text("MAKING SUBLETTING EASIER FOR UW STUDENTS")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(textMuted)
                        .tracking(1.6)

                    Spacer()

                    Button {
                        onStart()
                    } label: {
                        HStack(spacing: 8) {
                            Text("GET STARTED")
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
                    .buttonStyle(.plain)

                }
                .padding(.horizontal, 18)
                .padding(20)
                .background(background)
            }

        }
        
    }
}
