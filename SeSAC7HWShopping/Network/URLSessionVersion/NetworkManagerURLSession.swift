//
//  NetworkManagerURLSession.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 9/10/25.
//

import Foundation

final class NetworkManagerURLSession {
    static let shared = NetworkManagerURLSession()
    private init() {}

    enum NetworkError: Error {
        case invalidResponse
        case decoding
        case unknown
    }

    func callRequest<T: Decodable>(
        api: NaverAPIURLSessionRouter,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        //컴포넌트 생성
        var urlComponents = URLComponents()
        urlComponents.scheme = api.scheme
        urlComponents.host = api.host
        urlComponents.path = api.path

        //쿼리 주입
        var queryItems: [URLQueryItem] = []
        api.parameter.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems

        //리퀘 생성
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = api.method.rawValue

        //헤더 주입
        var headers = api.headers
        headers.forEach { key, value in
            request.addValue(key, forHTTPHeaderField: value)
        }

        //요청 시간 주입
        request.timeoutInterval = 5


        //세션시작
        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                //통신에러 처리
                if let error {
                    print("통신 에러 발생", error)
                    completion(.failure(error))
                    return
                }
				//상태코드 점검
                guard let response = response as? HTTPURLResponse else {
					print("올바르지 않은 response에러")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                switch response.statusCode {
                case (200...300):
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(type, from: data)
                            completion(.success(result))
                        } catch {
                            print("디코딩 오류가 발생했다.")
                            completion(.failure(NetworkError.decoding))
                        }
                    }
                case (400...500):
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(NaverError.self, from: data)
                            completion(.failure(NaverError(errorMessage: result.errorMessage, errorCode: result.errorCode) as! Error))
                        } catch {
                            print("에러타입 디코딩 오류가 발생했다.")
                            completion(.failure(NetworkError.decoding))
                        }
                    }
                default:
                    print("올바르지 않은 상태코드")
                    completion(.failure(NetworkError.unknown))
                    return
                }



            }
        }.resume()
    }
}

