//
//  NetworkManager.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/28/25.
//

import Foundation
import Alamofire

enum NWError: Error {
    case naver(code: String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func callRequest<T: Decodable>(
        api: NaverAPIRouter,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameter,
            encoding: URLEncoding(destination: .queryString),
            headers: api.headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            let statusCode = response.response?.statusCode ?? 0
            print("네트워크 요청 statusCode", statusCode)

            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let afError):
                if (400..<500).contains(statusCode),
                   let data = response.data,
                   let naver = try? JSONDecoder().decode(NaverError.self, from: data) {
                    let err = NWError.naver(code: naver.errorCode)
                    completion(.failure(err))
                } else {
                    completion(.failure(afError))
                }
            }
        }
    }
}
