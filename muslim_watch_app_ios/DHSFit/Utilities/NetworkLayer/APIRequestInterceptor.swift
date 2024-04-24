//
//  RequestInterceptor.swift
//  HRA
//
//  Created by Alchemist on 19/05/2021.
//  Copyright © 2021 Cashless. All rights reserved.
//

import Alamofire
import Foundation

//final class APIRequestInterceptor: RequestInterceptor {
//    private let userDefaultsManager: UserDefaultsProtocol = UserDefaultsManager()
//    var accessToken: String {
//        userDefaultsManager.value(key: UserDefaultsKeys.userToken) ?? ""
//    }
//
//    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var urlRequest = urlRequest
//        urlRequest.headers.add(.authorization(bearerToken: accessToken))
//        completion(.success(urlRequest))
//    }
//
//    func retry(_: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) {
//        completion(.doNotRetry)
//    }
//}
