//
//  PriceFormatter.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/28/25.
//

import Foundation

class PriceFormatter {
    static let shared = PriceFormatter()
    let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    private init() {}
}
