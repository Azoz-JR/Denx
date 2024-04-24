//
//  TargetType.swift
//  Tournament
//
//  Created by Alchemist on 31/12/2020.
//  Copyright © 2020 Nejmo. All rights reserved.
//

import Alamofire
import Foundation

// MARK: BluePrint For Every Request

protocol TargetType {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Taskk { get }
    var headers: [String: String]? { get }
}

extension TargetType {
//    var baseUrl: String {
////    "https://dailyprayer.abdulrcs.repl.co/api/"
//        "https://denx.suppwhey.net/data/"
//    }

    var headers: [String: String]? {
        var headers = [String: String]()
        headers["Accept"] = "application/json"
        return headers
    }
}

// Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Task
enum Taskk {
    case normalRequest
    case WithParametersRequest(parameters: [String: Any], encoding: ParameterEncoding)
}
