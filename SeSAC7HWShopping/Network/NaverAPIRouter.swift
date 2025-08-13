//
//  Router.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/13/25.
//

import Foundation
import Alamofire

enum NaverAPIRouter {
    case searchResult(query: String, display: String = "100", sort: String = "sim", start: String = "1")
    case recommendList(query: String, display: String = "20", sort: String = "sim", start: String = "1")

    var baseURL: String {
        return "https://openapi.naver.com/"
    }

    var endpoint: URL {
        return URL(string: baseURL + "v1/search/shop.json")!
    }

    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
    }

    var method: HTTPMethod {
        return .get
    }

    var parameter: Parameters {
        switch self {
        case .searchResult(let query, let display, let sort, let start),
            .recommendList(let query, let display, let sort, let start):

            return [
                "query": query,
                "display": display,
                "sort": sort,
                "start": start
            ]
        }
    }
}
