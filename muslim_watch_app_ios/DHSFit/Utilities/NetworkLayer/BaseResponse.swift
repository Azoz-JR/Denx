//
//  BaseResponse.swift
//  Tournament
//
//  Created by Alchemist on 31/12/2020.
//  Copyright © 2020 Nejmo. All rights reserved.
//

import Foundation
class BaseResponse<T: Codable>: Codable {
    var status: Int?
    var message: String?
    var response: Response<T>?
    var data: T?
    var errors: [String]?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
        case errors
        case response
    }
}

struct Response<T: Codable>: Codable {
    var data: T?
}
