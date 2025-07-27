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

    let imageView = UIImageView()
    let brandLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

		configureHierachy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("스토리보드로 사용됨 에러")
    }
}

extension SearchResultCollectionViewCell: ViewDesignProtocol {
    func configureHierachy() {
        contentView.addSubview(imageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(brandLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(brandLabel)
        }

    }
    
    func configureView() {
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue

        brandLabel.font = .systemFont(ofSize: 12, weight: .bold)
        brandLabel.textColor = .systemGray4

        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .systemGray5
        titleLabel.numberOfLines = 2

        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        priceLabel.textColor = .black
    }
}
