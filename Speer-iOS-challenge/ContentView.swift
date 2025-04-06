//
//  ContentView.swift
//  Speer-iOS-challenge
//
//  Created by Ehan kannuthurai on 2025-04-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GitHubViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .padding(.top, 40)

                    Text("Search for a GitHub user")
                        .font(.title2)
                        .fontWeight(.medium)

                    Text("Press return to search")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("Enter GitHub username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .frame(maxWidth: 300)

                    if let user = viewModel.user {
                        ProfileView(user: user, viewModel: viewModel)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                    } else {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            }
            .background(Color(.systemBackground))
            .navigationTitle("GitHub Search")
            .onSubmit {
                Task {
                    await viewModel.fetchUser()
                }
            }
            .refreshable {
                await viewModel.fetchUser()
            }
        }
    }
}

#Preview {
    ContentView()
}
