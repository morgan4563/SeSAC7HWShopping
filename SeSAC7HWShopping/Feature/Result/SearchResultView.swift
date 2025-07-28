//
//  SearchResultView.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/29/25.
//

import UIKit
import SnapKit

class SearchResultView: BaseView {
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

    override func configureHierachy() {
        addSubview(searchResultCountLabel)
        addSubview(filterButtonsStackView)
        addSubview(searchItemCollection)
    }

    override func configureLayout() {
        searchResultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
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

    override func configureView() {
        super.configureView()
        searchResultCountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        searchResultCountLabel.textColor = .green
    }
}
