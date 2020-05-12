//
//  UsersResponseModel.swift
//  GitHub
//
//  Created by Sanith on 5/6/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import Foundation
struct UsersResponseModel : Decodable {
    
    let total_count : Int?
    let incomplete_results : Bool?
    let items : [ItemsResponseModel]?

    enum CodingKeys: String, CodingKey {
        
        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        items = try values.decodeIfPresent([ItemsResponseModel].self, forKey: .items)
    }

}
