//
//  User.swift
//  GHFollowers
//
//  Created by Nicolas Rios on 4/11/22.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGist: Int
    var htmlUrl: String
    var following :Int
    var followers: Int
    var createdAt: String
    
}
