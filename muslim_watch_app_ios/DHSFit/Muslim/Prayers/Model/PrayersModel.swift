//
//  PrayersModel.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation

//struct PrayersTimes: Codable, Storeable {
//    let city, date: String?
//    let today: Today?
//    
//    var storeData: Data? {
//        let encoder = JSONEncoder()
//        let encoded = try? encoder.encode(self)
//        return encoded
//    }
//
//    init?(storeData: Data?) {
//        guard let storeData = storeData else {
//            return nil
//        }
//        let decoder = JSONDecoder()
//        guard let decoded = try? decoder.decode(PrayersTimes.self, from: storeData) else {
//            return nil
//        }
//        self = decoded
//    }
//}
//
//// MARK: - Today
//struct Today: Codable {
//    let asr, dhuhr, fajr, ishaA: String?
//    let maghrib, sunrise: String?
//
//    enum CodingKeys: String, CodingKey {
//        case asr = "Asr"
//        case dhuhr = "Dhuhr"
//        case fajr = "Fajr"
//        case ishaA = "Isha'a"
//        case maghrib = "Maghrib"
//        case sunrise = "Sunrise"
//    }
//}

struct PrayersTimes: Codable, Storeable {
    let code: Int?
    let status: String?
    let data: DataClass?
    
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
        guard let decoded = try? decoder.decode(PrayersTimes.self, from: storeData) else {
            return nil
        }
        self = decoded
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let timings: Timings?
    let date: DateClass?
    let meta: Meta?
}

// MARK: - DateClass
struct DateClass: Codable {
    let readable, timestamp: String?
    let hijri: Hijri?
    let gregorian: Gregorian?
}

// MARK: - Gregorian
struct Gregorian: Codable {
    let date, format, day: String?
    let weekday: GregorianWeekday?
    let month: GregorianMonth?
    let year: String?
    let designation: Designation?
}

// MARK: - Designation
struct Designation: Codable {
    let abbreviated, expanded: String?
}

// MARK: - GregorianMonth
struct GregorianMonth: Codable {
    let number: Int?
    let en: String?
}

// MARK: - GregorianWeekday
struct GregorianWeekday: Codable {
    let en: String?
}

// MARK: - Hijri
struct Hijri: Codable {
    let date, format, day: String?
    let weekday: HijriWeekday?
    let month: HijriMonth?
    let year: String?
    let designation: Designation?
//    let holidays: [JSONAny]
}

// MARK: - HijriMonth
struct HijriMonth: Codable {
    let number: Int?
    let en, ar: String?
}

// MARK: - HijriWeekday
struct HijriWeekday: Codable {
    let en, ar: String?
}

// MARK: - Meta
struct Meta: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let method: Method?
    let latitudeAdjustmentMethod, midnightMode, school: String?
//    let offset: [String: Int]?
}

// MARK: - Method
struct Method: Codable {
    let id: Int?
    let name: String?
    let params: Params?
    let location: Location?
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double?
}

// MARK: - Params
struct Params: Codable {
    let fajr, isha: Float?

    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case isha = "Isha"
    }
}

// MARK: - Timings
struct Timings: Codable {
    let fajr, sunrise, dhuhr, asr: String?
    let sunset, maghrib, isha, imsak: String?
    let midnight, firstthird, lastthird: String?

    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case sunset = "Sunset"
        case maghrib = "Maghrib"
        case isha = "Isha"
        case imsak = "Imsak"
        case midnight = "Midnight"
        case firstthird = "Firstthird"
        case lastthird = "Lastthird"
    }
}
