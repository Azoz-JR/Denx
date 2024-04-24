//
//  NetworkResponseErrors.swift
//  Tournament
//
//  Created by Alchemist on 31/12/2020.
//  Copyright © 2020 Nejmo. All rights reserved.
//

import Foundation

// MARK: Our Custom Static Errors...

enum NetworkResponseErrors: String, Error {
    case noStatusCode = "Something went wrong , please try again!"
    case noResponseFound = "Can't Get Response."
    case cantParseJson = "Can't Parse Json."
    case badUrl = "404 Status Code , via bad URL."
    case unAuthenticated = "you need to be authenticated."
    case outDated = "The url you requested is outdated."
    case failed = "Network request failed."
    case wrongData = "Check your entered data."
    case haventGameId = "Haven't Game ID"
}
