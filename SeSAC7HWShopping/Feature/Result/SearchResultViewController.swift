//
//  SearchResultViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultViewController: UIViewController {
    let searchResultView = SearchResultView()

    var searchText: String = ""
    var list: SearchItem = SearchItem(total: 0, start: 1, items: [])
    var start = 1
    var displayCountString = "30"
    var isEnd = false

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetViewData()
        configureCollectionView()
        callRequest(query: searchText, display: displayCountString)

        //네비게이션 설정
        title = searchText

        //버튼 세팅
        searchResultView.filterButtonsStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(self, action: #selector(filterButtonClicked(_:)), for: .touchUpInside)
            }
        }
    }

    private func resetViewData() {
        start = 1
        isEnd = false
        list = SearchItem(total: 0, start: 1, items: [])
        searchResultView.searchItemCollection.reloadData()
    }

    private func configureCollectionView() {
        searchResultView.searchItemCollection.delegate = self
        searchResultView.searchItemCollection.dataSource = self
        searchResultView.searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }

    private func callRequest(query: String, display: String, sort: String = "sim") {
        if start > 1000 {
            self.isEnd = true
        }

        if isEnd { return }

        NetworkManager.shared.callRequest(query: query, display: display, sort: sort, start: start) {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                self.searchResultView.searchResultCountLabel.text = "\(value.total.formatted()) 개의 검색 결과"
                self.list.items.append(contentsOf: value.items)
                let maxTotal = min(value.total, 1000)
                isEnd = list.items.count >= maxTotal || value.items.count == 0

                self.searchResultView.searchItemCollection.reloadData()

                if self.start == 1 && !isEnd {
                    self.searchResultView.searchItemCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case .failure(let error):
                print("fail", error)
                let alert = UIAlertController(title: "네트워크 에러", message: "요청에 실패했습니다. 검색어를 다시 입력해 주세요", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default) {_ in 
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(confirm)
                present(alert, animated: true)
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
        callRequest(query: searchText, display: displayCountString, sort: sort)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = list.items[indexPath.item]
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
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function, indexPath.item, isEnd, list.items.count)
        if isEnd == false && indexPath.item == list.items.count - 3 {
            print(1)
            start += Int(displayCountString)!
            callRequest(query: searchText, display: displayCountString)
        }
    }
}
