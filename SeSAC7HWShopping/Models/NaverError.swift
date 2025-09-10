//
//  NaverError.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/30/25.
//

struct NaverError: Decodable, Error {
    let errorMessage: String
    let errorCode: String
}
