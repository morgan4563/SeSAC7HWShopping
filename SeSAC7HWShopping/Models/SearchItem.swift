//
//  SearchItem.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/28/25.
//

import Foundation

struct SearchItem: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
}
