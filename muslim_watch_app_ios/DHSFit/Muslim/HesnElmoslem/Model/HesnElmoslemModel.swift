//
//  HesnElmoslemModel.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation

struct HesnElmoslemModel: Codable, Storeable {
//    let code: Int?
//    let data: [HesnElmoslemData]?
//    let msg: String?
    let id: Int?
        let header: String?
        let body: String?
    
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
        guard let decoded = try? decoder.decode(HesnElmoslemModel.self, from: storeData) else {
            return nil
        }
        self = decoded
    }

}

// MARK: - Datum
struct HesnElmoslemData: Codable {
    let id: Int?
    let header: String?
    let body: String?
}
