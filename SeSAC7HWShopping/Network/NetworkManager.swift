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

    func callRequest(query: String, display: String = "100", sort: String = "sim", start: Int = 1, completion: @escaping (Result<SearchItem, Error>) -> Void) {

        let url = "https://openapi.naver.com/v1/search/shop.json"

        let parameters: [String: String] = [
            "query" : query,
            "display" : display,
            "sort" : sort,
            "start" : String(start)
        ]

        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]

        AF.request(url, method: .get, parameters: parameters, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchItem.self) { response in
                print("파라미터", parameters)
                switch response.result {
                case .success(let value):
                    completion(.success(value))

                case .failure(let afError):
                    let statusCode = response.response?.statusCode ?? 0
					print("네트워크 메니저 에러", statusCode)
                    // try? 처리필요
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
