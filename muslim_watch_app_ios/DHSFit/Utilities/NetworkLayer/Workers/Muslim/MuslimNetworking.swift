//
//  MuslimNetworking.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Alamofire
import Foundation

enum MuslimNetworking {
    case prayerTimes(date: String, lat: String, lng: String)
    case hesnElmoslem(lang: String)
    case adaih(lang: String)
    case quran(lang: String)
}

extension MuslimNetworking: TargetType {
    var baseUrl: String {
        switch self {
        case .prayerTimes:
//            return "https://dailyprayer.abdulrcs.repl.co/api/"
            return "http://api.aladhan.com/v1/timings/"
        case .hesnElmoslem, .adaih, .quran:
//            return "https://denx.suppwhey.net/data/"
//            return "http://denx-dashboard.suppwhey.net/api/"
            return "http://denx.cloud/api/"
        }
    }
    
    var path: String {
        switch self {
        case let .prayerTimes(date, lat, lng):
            return "\(date)?latitude=\(lat)&longitude=\(lng)"
        case let .hesnElmoslem(lang):
            return "hesn-el-muslim?lang=\(lang)"
        case let .adaih(lang):
            return "doaa-audios?lang=\(lang)"
        case let .quran(lang):
            return "quran?lang=\(lang)"
        }
    }

    
    
    var method: HTTPMethod {
        switch self {
        case .prayerTimes, .adaih, .hesnElmoslem, .quran:
            return .get
        }
    }

    var task: Taskk {
        switch self {
        case .prayerTimes, .adaih, .hesnElmoslem, .quran:
            return .normalRequest
        }
    }
}
