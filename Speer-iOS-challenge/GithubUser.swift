//
//  GithubUser.swift
//  Speer-iOS-challenge
//
//  Created by Ehan kannuthurai on 2025-04-06.
//

import SwiftUI


struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let name: String?
    let bio: String?
    let followers: Int
    let following: Int
}


struct GitHubUserLite: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
}
