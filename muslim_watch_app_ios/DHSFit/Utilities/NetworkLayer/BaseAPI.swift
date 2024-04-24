//
//  BaseAPI.swift
//  Tournament
//
//  Created by Alchemist on 31/12/2020.
//  Copyright © 2020 Nejmo. All rights reserved.
//

import Alamofire
import Foundation
class BaseAPI<T: TargetType> {
    func performRequest<M: Decodable>(target: T, responseClass _: M.Type, completion: @escaping (Swift.Result<M?, NetworkResponseErrors>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)!
        let parameters = buildParameters(withTask: target.task)
        let headers = buildHeaders(withHeader: target.headers)
        Alamofire.request(target.baseUrl + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers ?? nil/*, interceptor: APIRequestInterceptor()*/).responseJSON { response in
//            guard let statusCode = response.response?.statusCode else {
//                // We Should add Custom Error here...
//                completion(.failure(.noStatusCode))
//                return
//            }
            print("\n\n\(response.request?.url)\n\n")
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    // We Should add Custom Error that we can't get Json Data
                    completion(.failure(.cantParseJson))
                    return
                }
                do {
                    let responseObject = try JSONDecoder().decode(M.self, from: jsonData)
                    print("------------------------\(target.path)-----------------------------------------------")
                    print(responseObject)
                    print("🕺 🕺 🕺 🕺 🕺🕺 💪")
                    completion(.success(responseObject))
                } catch {
                    print(target.baseUrl + target.path)
                    print("------------------------\(target.path)-----------------------------------------------")
                    print(error)
                    print("🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫")
                    completion(.failure(.cantParseJson))
                    return
                }
            case .failure:
                print("-----------------------------------------------------------------------")
//                print(self.generateError(statusCode).rawValue)
                print("🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫 🚫")
//                print("Status Code = \(statusCode)")
//                completion(.failure(self.generateError(statusCode)))
            }
        }
    }

    private func buildParameters(withTask task: Taskk) -> ([String: Any]?, ParameterEncoding) {
        switch task {
        case .normalRequest:
            return (nil, URLEncoding.default)
        case let .WithParametersRequest(parameters: parameters, encoding: encoding):
            return (parameters, encoding)
        }
    }

    private func buildHeaders(withHeader headers: [String: String]?) -> HTTPHeaders? {
        if let header = headers {
            return header//HTTPHeaders(header)
        } else {
            return nil
        }
        //  return headers == nil ? nil : HTTPHeaders.init(headers!)
    }

    private func generateError(_ statusCode: Int) -> NetworkResponseErrors {
        switch statusCode {
        case 422:
            return .wrongData
        case 401 ... 500:
            return .unAuthenticated
        case 501 ... 599:
            return .outDated
        case 600:
            return .badUrl
        default:
            return .failed
        }
    }
}
