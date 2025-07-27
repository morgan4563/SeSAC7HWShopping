//
//  SearchResultCollectionViewCell.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"

    let itemImageView = UIImageView()


    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(itemImageView)
        itemImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        itemImageView.contentMode = .scaleAspectFit
        itemImageView.backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("스토리보드로 사용됨 에러")
    }
}
