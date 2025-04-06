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
    
    private var userCache: [String: (data: GitHubUser, timestamp: Date)] = [:]
    private let cacheExpiration: TimeInterval = 600 // 10 minutes

    func fetchUser() async {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUsername.isEmpty else { return }
        if let cached = userCache[trimmedUsername],
           Date().timeIntervalSince(cached.timestamp) < cacheExpiration {
            self.user = cached.data
            self.errorMessage = nil
            print("Loaded from cache")
            return
        }

        let url = URL(string: "https://api.github.com/users/\(trimmedUsername)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedUser = try JSONDecoder().decode(GitHubUser.self, from: data)
            self.user = decodedUser
            self.errorMessage = nil
            self.userCache[trimmedUsername] = (decodedUser, Date())
            print("Fetched from network")
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

    func invalidateCache(for username: String) {
        userCache.removeValue(forKey: username)
    }

    func clearCache() {
        userCache.removeAll()
    }
}
