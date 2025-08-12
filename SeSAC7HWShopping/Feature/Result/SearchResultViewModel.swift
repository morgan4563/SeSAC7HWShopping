//
//  SearchResultViewModel.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/12/25.
//

import Foundation

final class SearchResultViewModel {
    let filterButtonClicked = Observable(value: ())
    let inputTitleText: Observable<String?> = Observable(value: "")
    let outputTitleText = Observable(value: "")
    var list = Observable(value: SearchItem(total: 0, start: 1, items: []))
    let recommendList = Observable(value: SearchItem(total: 0, start: 1, items: []))

    var start = 1
	var displayCountString = "30"
    var isEnd = false

    init() {
        inputTitleText.bind { [weak self] _ in
            guard let self else { return }
            self.setTitle()
        }
    }

    func setTitle() {
        guard let text = inputTitleText.value else { return }
        outputTitleText.value = text
    }
}
