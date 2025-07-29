//
//  SearchResultRecommendCollectionViewCell.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/30/25.
//

import UIKit
import SnapKit

class SearchResultRecommendCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "SearchResultRecommendCollectionViewCell"

    let imageView = UIImageView()

    override func configureHierachy() {
        contentView.addSubview(imageView)
    }

    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
    }

    override func configureView() {
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
    }
}
