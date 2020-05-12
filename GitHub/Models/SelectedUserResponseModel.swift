//
//  SelectedUserResponseModel.swift
//  GitHub
//
//  Created by Sanith on 5/6/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import Foundation

struct SelectedUserResponseModel : Decodable {
    
    let login : String?
    let id : Int?
    let avatar_url : String?
    let url : String?
    let starred_url : String?
    let subscriptions_url : String?
    let repos_url : String?
    let location : String?
    let email : String?
    let bio : String?
    let public_repos : Int?
    let public_gists : Int?
    let followers : Int?
    let following : Int?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case login = "login"
        case id = "id"
        case node_id = "node_id"
        case avatar_url = "avatar_url"
        case gravatar_id = "gravatar_id"
        case url = "url"
        case html_url = "html_url"
        case followers_url = "followers_url"
        case following_url = "following_url"
        case gists_url = "gists_url"
        case starred_url = "starred_url"
        case subscriptions_url = "subscriptions_url"
        case organizations_url = "organizations_url"
        case repos_url = "repos_url"
        case events_url = "events_url"
        case received_events_url = "received_events_url"
        case type = "type"
        case site_admin = "site_admin"
        case name = "name"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case email = "email"
        case hireable = "hireable"
        case bio = "bio"
        case public_repos = "public_repos"
        case public_gists = "public_gists"
        case followers = "followers"
        case following = "following"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        starred_url = try values.decodeIfPresent(String.self, forKey: .starred_url)
        subscriptions_url = try values.decodeIfPresent(String.self, forKey: .subscriptions_url)
        repos_url = try values.decodeIfPresent(String.self, forKey: .repos_url)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        public_repos = try values.decodeIfPresent(Int.self, forKey: .public_repos)
        public_gists = try values.decodeIfPresent(Int.self, forKey: .public_gists)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }

}
