//
//  SearchResultViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import SnapKit

class SearchResultViewController: UIViewController {
    var searchText: String = ""
    let searchResultCountLabel = UILabel()
    let searchItemCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (16 * 2) - (16 * 1)

        layout.itemSize = CGSize(width: cellWidth/2, height: cellWidth/2 + 70)
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

        configureCollectionView()
    }

    private func configureCollectionView() {
        searchItemCollection.delegate = self
        searchItemCollection.dataSource = self
        searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }
}

extension SearchResultViewController: ViewDesignProtocol {
    func configureHierachy() {
        view.addSubview(searchResultCountLabel)
        view.addSubview(searchItemCollection)
    }
    
    func configureLayout() {
        searchResultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        searchItemCollection.snp.makeConstraints { make in
            make.top.equalTo(searchResultCountLabel.snp.bottom).offset(16)
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.itemImageView.backgroundColor = .red

        return cell
    }
}
