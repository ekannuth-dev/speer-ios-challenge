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
            VStack {
                Text("Enter a GitHub username")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                Text("Press return to search")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
                
                TextField("Enter GitHub username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding()
                if let user = viewModel.user {
                    ProfileView(user: user, viewModel: viewModel)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Spacer()
                }
            }
            .navigationTitle("GitHub Search")
            .onSubmit {
                Task {
                    await viewModel.fetchUser()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
