//
//  MuslimWorker.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation

protocol MuslimWorkerProtocol {
    func prayerTimes(_ date: String,_ lat: String,_ lng: String, completion: @escaping (Swift.Result<PrayersTimes?, NetworkResponseErrors>) -> Void)
    func hesnElmoslem(_ lang: String, completion: @escaping(Result<[HesnElmoslemModel]?, NetworkResponseErrors>) -> Void)
    func adaih(_ lang: String, completion: @escaping (Result<[AdaihModel]?, NetworkResponseErrors>) -> Void)
    func quran(_ lang: String, completion: @escaping (Result<[QuranModel]?, NetworkResponseErrors>) -> Void)
}

class MuslimWorker: BaseAPI<MuslimNetworking>, MuslimWorkerProtocol {
    func prayerTimes(_ date: String,_ lat: String,_ lng: String, completion: @escaping (Result<PrayersTimes?, NetworkResponseErrors>) -> Void) {
        self.performRequest(target: .prayerTimes(date: date, lat: lat, lng: lng), responseClass: PrayersTimes.self) { results in
            completion(results)
        }
    }
    
    func hesnElmoslem(_ lang: String, completion: @escaping (Result<[HesnElmoslemModel]?, NetworkResponseErrors>) -> Void) {
        self.performRequest(target: .hesnElmoslem(lang: lang), responseClass: [HesnElmoslemModel].self) { result in
            completion(result)
        }
    }
    
    func adaih(_ lang: String, completion: @escaping (Result<[AdaihModel]?, NetworkResponseErrors>) -> Void) {
        self.performRequest(target: .adaih(lang: lang), responseClass: [AdaihModel].self) { result in
            completion(result)
        }
    }
    
    func quran(_ lang: String, completion: @escaping (Result<[QuranModel]?, NetworkResponseErrors>) -> Void) {
        self.performRequest(target: .quran(lang: lang), responseClass: [QuranModel].self) { result in
            completion(result)
        }
    }
}
