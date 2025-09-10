//
//  SearchResultViewModel.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/12/25.
//

import Foundation

final class SearchResultViewModel {
    var input: Input
    var output: Output

    struct Input {
        // 1페이지에서 검색어 받았을때
        let titleText: Observable<String?> = Observable(value: "")
        // 정렬버튼 클릭했을때
        let filterButtonClicked = Observable(value: ())
        // 검색 시도됐을때
        let searchTrigger: Observable<Void?> = Observable(value: ())
    }

    struct Output {
        // 타이틀
        let titleText = Observable(value: "")
        // 검색 갯수 결과
        let searchCountText = Observable(value: "")
        // 화면 리로드 될때, 스크롤 처리
        let loading = Observable(value: ())
        // 리스트, 페이지리로두
        var list = Observable(value: SearchItem(total: 0, start: 1, items: []))
        // 추천검색어 리스트, 페이지 리로드
        let recommendList = Observable(value: SearchItem(total: 0, start: 1, items: []))
        //에러 메시지 발생
        let errorPresent: Observable<String?> = Observable(value: nil)
    }

    // MARK: - Other
    var start = 1
    var sortKeyword = "sim"
    var isEnd = false

    init() {
		input = Input()
        output = Output()

        input.titleText.lazyBind { [weak self] _ in
            guard let self else { return }
            self.setTitle()
        }

        input.searchTrigger.lazyBind { [weak self] _ in
            guard let self else { return }
            guard !output.titleText.value.isEmpty else { return }
            self.callRequest(query: output.titleText.value, sort: "sim")
        }

        input.filterButtonClicked.lazyBind { [weak self] _ in
            guard let self else { return }
            self.resetViewData()

            let sort: String
            switch sortKeyword {
            case "날짜순": sort = "date"
            case "가격높은순": sort = "dsc"
            case "가격낮은순": sort = "asc"
            default: sort = "sim"
            }

            self.callRequest(query: output.titleText.value, sort: sort)
        }
    }

    private func setTitle() {
        guard let text = input.titleText.value else { return }
        output.titleText.value = text
    }

    private func callRequest(query: String, sort: String) {
        if start > 1000 { isEnd = true }
        if isEnd { return }
        #warning("여기서 세션통신으로 변경해봄")
        let router = NaverAPIURLSessionRouter.searchResult(query: query, display: "100", sort: sort, start: "\(start)")
        NetworkManagerURLSession.shared.callRequest(api: router, type: SearchItem.self) { [weak self] result in
            guard let self else { return }
			print("뭐가문제 \(result)")
            switch result {
            case .success(let value):
                output.searchCountText.value = "\(value.total.formatted()) 개의 검색 결과"

                let maxTotal = min(value.total, 1000)
                isEnd = output.list.value.items.count + value.items.count >= maxTotal || value.items.isEmpty
                output.list.value.items.append(contentsOf: value.items)

                if start == 1 && !isEnd {
                    output.loading.value = ()
                }
                
            case .failure(let error):
				errorHandling(error: error)
            }
        }

		callRecommandList()
    }

    private func callRecommandList() {
        let router = NaverAPIRouter.recommendList(query: "새싹", display: "10")
        NetworkManager.shared.callRequest(api: router, type: SearchItem.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                output.recommendList.value.items = value.items
            case .failure(let error):
                print("fail", error)
            }
        }
    }

    private func errorHandling(error: Error) {
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
        output.errorPresent.value = msg
    }

    private func resetViewData() {
        start = 1
        isEnd = false
        output.list.value = SearchItem(total: 0, start: 1, items: [])
    }
}
