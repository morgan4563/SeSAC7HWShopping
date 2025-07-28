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
    var searchText: String = ""
    var list: SearchItem = SearchItem(total: 0, start: 1, items: [])

    var start = 1
    var isEnd = false

    let searchResultCountLabel = UILabel()
    let filterButtonsStackView: UIStackView = {
        let buttons = ["정확도","날짜순","가격높은순","가격낮은순"].map {
            let button = UIButton(type: .system)
            button.setTitle($0, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.setTitleColor(.label, for: .normal)

            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1

            return button
        }
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 8
        return sv
    }()

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
        callRequest(query: searchText, sort: sort)
    }

    let searchItemCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (16 * 2) - (16 * 1)

        layout.itemSize = CGSize(width: cellWidth/2, height: cellWidth/2 + 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureLayout()
        configureView()

        resetViewData()
        configureCollectionView()
        callRequest(query: searchText)
    }

    private func resetViewData() {
        start = 1
        isEnd = false
        list = SearchItem(total: 0, start: 1, items: [])
        searchItemCollection.reloadData()
    }

    private func configureCollectionView() {
        searchItemCollection.delegate = self
        searchItemCollection.dataSource = self
        searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }

    private func callRequest(query: String, display: String = "30", sort: String = "sim", start: Int = 1) {
        if isEnd { return }

        NetworkManager.shared.callRequest(query: query, display: display, sort: sort, start: start) {
            [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                if start > 100 || start > Int(ceil(Double(value.total) / Double(30))) {
                    self.isEnd = true
                }

                self.searchResultCountLabel.text = "\(value.total.formatted()) 개의 검색 결과"
                self.list.items.append(contentsOf: value.items)
                self.searchItemCollection.reloadData()

                if self.start == 1 {
                    self.searchItemCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case .failure(let error):
                print("fail", error)
            }
        }
    }
}

extension SearchResultViewController: ViewDesignProtocol {
    func configureHierachy() {
        view.addSubview(searchResultCountLabel)
        view.addSubview(filterButtonsStackView)
        view.addSubview(searchItemCollection)
    }

    func configureLayout() {
        searchResultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        filterButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(searchResultCountLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        searchItemCollection.snp.makeConstraints { make in
            make.top.equalTo(filterButtonsStackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureView() {
        view.backgroundColor = .systemBackground
        title = searchText

        searchResultCountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        searchResultCountLabel.textColor = .green
        searchResultCountLabel.text = "12,235,1243 개의 검색 결과"

        filterButtonsStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(self, action: #selector(filterButtonClicked(_:)), for: .touchUpInside)
            }
        }
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
        if indexPath.item == list.items.count - 3 && isEnd == false {
            start += 1
            callRequest(query: searchText, start: start)
        }
    }
}
