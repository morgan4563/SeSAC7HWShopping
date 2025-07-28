//
//  SearchResultViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class SearchResultViewController: UIViewController {
    var searchText: String = ""
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

    var list: SearchItem = SearchItem(total: 0, items: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureLayout()
        configureView()

        configureCollectionView()
        callRequest(query: searchText)
    }

    private func configureCollectionView() {
        searchItemCollection.delegate = self
        searchItemCollection.dataSource = self
        searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }

    private func callRequest(query: String, display: String = "100") {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)"

		#warning("개인키 하드코딩 주의")
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "x1oU6MA5QdsSl3AvG56T",
            "X-Naver-Client-Secret" : "UCFzae3V3e"
        ]

        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchItem.self) { response in
                switch response.result {
                case .success(let value):
                    self.searchResultCountLabel.text = "\(value.total.formatted()) 개의 검색 결과"
                    self.list = value
                    self.searchItemCollection.reloadData()
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
            let nf = NumberFormatter()
            nf.numberStyle = .decimal

            let decimalPrice = nf.string(for: price)
            cell.priceLabel.text = decimalPrice
        } else {
            cell.priceLabel.text = item.lprice
        }

        return cell
    }
}
