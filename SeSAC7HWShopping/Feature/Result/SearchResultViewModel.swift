//
//  SearchResultViewModel.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/12/25.
//

import Foundation

final class SearchResultViewModel {

    // 1페이지에서 검색어 받았을때
    let inputTitleText: Observable<String?> = Observable(value: "")
    // 정렬버튼 클릭했을때
    let filterButtonClicked = Observable(value: ())
    // 검색 시도됐을때
    let searchTrigger = Observable(value: ())
    //에러 메시지 발생
    let errorPresent: Observable<String?> = Observable(value: nil)

    // 타이틀
    let outputTitleText = Observable(value: "")
    let outputSearchCountText = Observable(value: "")

    // 화면 리로드 될때, 스크롤 처리
    let loading = Observable(value: ())

    // 리스트, 페이지리로두
    var list = Observable(value: SearchItem(total: 0, start: 1, items: []))

    // 추천검색어 리스트, 페이지 리로드
    let recommendList = Observable(value: SearchItem(total: 0, start: 1, items: []))


    var start = 1
    var sortKeyword = "sim"
	var displayCountString = "100"
    var isEnd = false

    init() {
        inputTitleText.bind { [weak self] _ in
            guard let self else { return }
            self.setTitle()
        }

        searchTrigger.bind { [weak self] _ in
            guard let self else { return }
            print("서치 1")
            self.resetViewData()
            self.callRequest(query: outputTitleText.value)
        }

        filterButtonClicked.bind { [weak self] _ in
            guard let self else { return }
            self.resetViewData()
            self.callRequest(query: outputTitleText.value, sort: sortKeyword)
            //sortKeyword 외부에서 실행전 받아야함
        }
    }

    private func setTitle() {
        guard let text = inputTitleText.value else { return }
        outputTitleText.value = text
    }

    private func callRequest(query: String, sort: String = "sim") {
        if start > 1000 {
            isEnd = true
        }

        if isEnd { return }

        NetworkManager.shared.callRequest(query: query, sort: sort) {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                print("잘됨 1")
                outputSearchCountText.value = "\(value.total.formatted()) 개의 검색 결과"

                let maxTotal = min(value.total, 1000)
                isEnd = list.value.items.count + value.items.count >= maxTotal || value.items.count == 0

                list.value.items.append(contentsOf: value.items)

                if start == 1 && !isEnd {
                    loading.value = ()
                }
            case .failure(let error):
                print("잘못1")
                var msg = "요청에 실패했습니다. 검색어를 다시 입력해 주세요"
                if let nw = error as? NWError {
                    switch nw {
                    case .naver(let code):
                        switch code {
                        case "SE01":
                            print("잘못2")
                            msg = "잘못된 쿼리 요청입니다"
                        case "SE02":
                            print("잘못3")
                            msg = "부적절한 display 값입니다."
                        case "SE03":
                            msg = "부적절한 start 값입니다."
                        case "SE04":
                            msg = "부적절한 sort 값입니다."
                        case "SE06":
                            msg = "잘못된 형식의 인코딩입니다."
                        case "SE05":
                            msg = "존재하지 않는 검색 api 입니다."
                        default:
                            break
                        }
                    }
                }
                errorPresent.value = msg
            }
        }

        NetworkManager.shared.callRequest(query: "새싹", display: "10") {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                recommendList.value.items = value.items
            case .failure(let error):
                print("fail", error)
            }
        }
    }

    private func resetViewData() {
        start = 1
        isEnd = false
        list.value = SearchItem(total: 0, start: 1, items: [])
    }
}
