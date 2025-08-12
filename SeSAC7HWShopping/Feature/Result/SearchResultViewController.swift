//
//  SearchResultViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController {
    let viewModel = SearchResultViewModel()
    let searchResultView = SearchResultView()

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetViewData()
        configureCollectionView()
        bind()

        //버튼 세팅
        searchResultView.filterButtonsStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(self, action: #selector(filterButtonClicked(_:)), for: .touchUpInside)
            }
        }
    }

    private func bind() {
        viewModel.outputTitleText.bind { [weak self] _ in
            guard let self else { return }
            self.navigationItem.title = self.viewModel.outputTitleText.value
            self.callRequest(query: viewModel.outputTitleText.value, display: "100")
        }

        viewModel.list.bind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchItemCollection.reloadData()
        }

        viewModel.recommendList.bind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchRecommendCollection.reloadData()
        }
    }

    private func resetViewData() {
        viewModel.start = 1
        viewModel.isEnd = false
        viewModel.list.value = SearchItem(total: 0, start: 1, items: [])
    }

    private func configureCollectionView() {
        searchResultView.searchItemCollection.delegate = self
        searchResultView.searchItemCollection.dataSource = self
        searchResultView.searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)

        searchResultView.searchRecommendCollection.delegate = self
        searchResultView.searchRecommendCollection.dataSource = self
        searchResultView.searchRecommendCollection.register(SearchResultRecommendCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultRecommendCollectionViewCell.identifier)
    }

    private func callRequest(query: String, display: String, sort: String = "sim") {
        if viewModel.start > 1000 {
            viewModel.isEnd = true
        }

        if viewModel.isEnd { return }

        NetworkManager.shared.callRequest(query: query, display: display, sort: sort, start: viewModel.start) {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                self.searchResultView.searchResultCountLabel.text = "\(value.total.formatted()) 개의 검색 결과"

                let maxTotal = min(value.total, 1000)
                viewModel.isEnd = viewModel.list.value.items.count + value.items.count >= maxTotal || value.items.count == 0

                viewModel.list.value.items.append(contentsOf: value.items)

                if viewModel.start == 1 && !viewModel.isEnd {
                    self.searchResultView.searchItemCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case .failure(let error):
                var msg = "요청에 실패했습니다. 검색어를 다시 입력해 주세요"
                if let nw = error as? NWError {
                    switch nw {
                    case .naver(let code):
                        switch code {
                        case "SE01":
							msg = "잘못된 쿼리 요청입니다"
                        case "SE02":
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
                let alert = UIAlertController(title: "네트워크 에러", message: msg, preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default) {_ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(confirm)
                present(alert, animated: true)
            }
        }

        NetworkManager.shared.callRequest(query: "새싹", display: "10") {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                viewModel.recommendList.value.items = value.items
            case .failure(let error):
                print("fail", error)
            }
        }
    }

    @objc func filterButtonClicked(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        let sort: String
        switch title {
        case "날짜순":
            sort = "date"
        case "가격높은순":
            sort = "dsc"
        case "가격낮은순":
            sort = "asc"
        default:
            sort = "sim"
        }
        resetViewData()
        callRequest(query: viewModel.outputTitleText.value, display: "100", sort: sort)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchResultView.searchItemCollection {
            return viewModel.list.value.items.count
        } else {
            return viewModel.recommendList.value.items.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchResultView.searchItemCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
                return UICollectionViewCell()
            }

            let item = viewModel.list.value.items[indexPath.item]
            if let imageURL = URL(string: item.image) {
                cell.imageView.kf.setImage(with: imageURL)
            }
            cell.mallLabel.text = item.mallName
            cell.titleLabel.text = item.title.tagDeleted

            if let price = Int(item.lprice) {
                let decimalPrice = PriceFormatter.shared.formatter.string(for: price)
                cell.priceLabel.text = decimalPrice
            } else {
                cell.priceLabel.text = item.lprice
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultRecommendCollectionViewCell.identifier, for: indexPath) as? SearchResultRecommendCollectionViewCell else {
                return UICollectionViewCell()
            }

            let item = viewModel.recommendList.value.items[indexPath.item]
            if let imageURL = URL(string: item.image) {
                cell.imageView.kf.setImage(with: imageURL)
            }

            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.isEnd == false && indexPath.item == viewModel.list.value.items.count - 3 {
            viewModel.start += Int(viewModel.displayCountString)!
            callRequest(query: viewModel.inputTitleText.value ?? "", display: viewModel.displayCountString)
        }
    }
}
