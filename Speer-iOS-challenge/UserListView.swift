//
//  UserListView.swift
//  Speer-iOS-challenge
//
//  Created by Ehan kannuthurai on 2025-04-06.
//

import SwiftUI

struct UserListView: View {
    let title: String
    let fetchAction: () async -> Void
    let users: [GitHubUserLite]

    var body: some View {
        List(users) { user in
            NavigationLink(destination: ProfileFromUsernameView(username: user.login)) {
                HStack {
                    AsyncImage(url: URL(string: user.avatar_url)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                    Text(user.login)
                }
            }
        }
        .navigationTitle(title)
        .task {
            await fetchAction()
        }
    }
}


struct ProfileFromUsernameView: View {
    let username: String
    @StateObject var viewModel = GitHubViewModel()

    var body: some View {
        Group {
            if let user = viewModel.user {
                ProfileView(user: user, viewModel: viewModel)
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            viewModel.username = username
            await viewModel.fetchUser()
        }
    }
}

