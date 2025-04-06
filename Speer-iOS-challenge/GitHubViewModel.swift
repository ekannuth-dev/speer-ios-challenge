//
//  GitUserViewModel.swift
//  Speer-iOS-challenge
//
//  Created by Ehan kannuthurai on 2025-04-06.
//
import SwiftUI


@MainActor
class GitHubViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var followers: [GitHubUserLite] = []
    @Published var following: [GitHubUserLite] = []
    @Published var errorMessage: String?
    @Published var username: String = ""
    
    func fetchUser() async {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.user = try JSONDecoder().decode(GitHubUser.self, from: data)
            self.errorMessage = nil
        } catch {
            self.user = nil
            self.errorMessage = "User not found or network error."
        }
    }
    
    func fetchFollowers(for username: String) async {
        let url = URL(string: "https://api.github.com/users/\(username)/followers")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.followers = try JSONDecoder().decode([GitHubUserLite].self, from: data)
        } catch {
            self.followers = []
        }
    }
    
    func fetchFollowing(for username: String) async {
        let url = URL(string: "https://api.github.com/users/\(username)/following")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.following = try JSONDecoder().decode([GitHubUserLite].self, from: data)
        } catch {
            self.following = []
        }
    }
}
