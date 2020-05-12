//
//  UserReposModel.swift
//  GitHub
//
//  Created by Sanith on 5/6/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import Foundation

struct UserReposModel: Decodable {

    let name : String?
    let stargazers_count : Int?
    let forks : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case stargazers_count = "stargazers_count"
        case forks = "forks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        stargazers_count = try values.decodeIfPresent(Int.self, forKey: .stargazers_count)
        forks = try values.decodeIfPresent(Int.self, forKey: .forks)
    }

}
