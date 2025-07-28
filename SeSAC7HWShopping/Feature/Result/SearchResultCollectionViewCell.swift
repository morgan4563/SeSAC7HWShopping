//
//  SearchResultCollectionViewCell.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"

    let imageView = UIImageView()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let heartButton = UIButton()

    override func configureHierachy() {
        contentView.addSubview(imageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }

    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        heartButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
            make.size.equalTo(32)
        }

        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(mallLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(mallLabel)
        }
    }

    override func configureView() {
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue

        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .black
        heartButton.backgroundColor = .white
        heartButton.layer.cornerRadius = 16
        heartButton.clipsToBounds = true

        mallLabel.font = .systemFont(ofSize: 12, weight: .bold)
        mallLabel.textColor = .systemGray2

        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        priceLabel.textColor = .label
    }
}
