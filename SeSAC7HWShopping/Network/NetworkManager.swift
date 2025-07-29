//
//  NetworkManager.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/28/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func callRequest(query: String, display: String = "30", sort: String = "sim", start: Int = 1, completion: @escaping (Result<SearchItem, AFError>) -> Void) {

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
                completion(response.result)
            }
    }
}
