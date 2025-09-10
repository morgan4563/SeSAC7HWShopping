//
//  NaverAPIURLSessionRouter.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 9/10/25.
//

import Foundation

enum HTTPSessionMethod: String {
    case get = "GET"
    case post = "POST"
    case delte = "DELETE"
}

enum NaverAPIURLSessionRouter {
    case searchResult(query: String, display: String = "100", sort: String = "sim", start: String = "1")
    case recommendList(query: String, display: String = "20", sort: String = "sim", start: String = "1")
//
//    var baseURL: String {
//        return "https://openapi.naver.com/"
//    }

    var scheme: String {
        return "https"
    }
    var host: String {
        return "openapi.naver.com"
    }
    var path: String {
        // 추후 붙을 거 필요하면 주자
        return ""
    }

//    var endpoint: URL {
//        return URL(string: baseURL + "v1/search/shop.json")!
//    }

    var headers: [String : String] {
		return [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
    }

    var method: HTTPSessionMethod {
        return .get
    }

    var parameter: [String : String] {
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
