//
//  SearchViewModel.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/12/25.
//

import Foundation

final class SearchViewModel {
    let searchButtonTapped = Observable(value: ())
    var inputText: String? = ""
    let outputTextValid = Observable(value: false)

    init() {
        searchButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            self.textValidation()
        }
    }

    private func textValidation() {
        guard let text = inputText, text.count >= 2 else {
            outputTextValid.value = false
            return
        }
        outputTextValid.value = true
    }
}
