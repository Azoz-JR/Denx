//
//  AdaihModel.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation

struct AdaihModel: Codable, Storeable {
    
//    let code: Int?
//    var data: [DuaaData]?
//    let msg: String?
    let id: Int?
        let url: String?
        let title: String?
    var played: Bool?
    
    var storeData: Data? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return encoded
    }

    init?(storeData: Data?) {
        guard let storeData = storeData else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(AdaihModel.self, from: storeData) else {
            return nil
        }
        self = decoded
    }
}

// MARK: - Datum
struct DuaaData: Codable {
    let id: Int?
    let url, title: String?
    var played: Bool?
}
