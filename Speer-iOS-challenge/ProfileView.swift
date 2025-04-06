//
//  ProfileView.swift
//  Speer-iOS-challenge
//
//  Created by Ehan kannuthurai on 2025-04-06.
//

import SwiftUI


struct ProfileView: View {
    let user: GitHubUser
    @ObservedObject var viewModel: GitHubViewModel
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: user.avatar_url)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())

            Text(user.login).font(.title)
            if let name = user.name {
                Text(name).font(.headline)
            }
            if let bio = user.bio {
                Text(bio).font(.body).padding(.horizontal)
            }

            HStack {
                NavigationLink("Followers: \(user.followers)", destination: UserListView(title: "Followers", fetchAction: {
                    await viewModel.fetchFollowers(for: user.login)
                }, users: viewModel.followers))

                NavigationLink("Following: \(user.following)", destination: UserListView(title: "Following", fetchAction: {
                    await viewModel.fetchFollowing(for: user.login)
                }, users: viewModel.following))
            }
            Spacer()
        }
        .padding()
    }
}
