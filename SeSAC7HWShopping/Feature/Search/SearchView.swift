//
//  SearchView.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/29/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    let searchBar = UISearchBar()
    let mainContainerView = UIView()
    let titleStackView = UIStackView()
    let titleImage = UIImageView()
    let titleLabel = UILabel()

    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(mainContainerView)
        mainContainerView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleImage)
        titleStackView.addArrangedSubview(titleLabel)
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }

        titleStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        titleImage.snp.makeConstraints { make in
            make.size.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
    }

    override func configureView() {
        backgroundColor = .systemBackground
        mainContainerView.backgroundColor = .systemBackground

        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal

        titleImage.contentMode = .scaleAspectFit
        titleImage.image = UIImage(named: "noMoneyMan")

        titleStackView.alignment = .center
        titleStackView.axis = .vertical

        titleLabel.text = "쇼핑하구팡"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
    }
}
