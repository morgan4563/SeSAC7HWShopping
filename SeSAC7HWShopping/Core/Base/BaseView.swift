//
//  BaseView.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/29/25.
//

import UIKit

class BaseView: UIView, ViewDesignProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierachy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init has not benn implemented")
    }

    func configureHierachy() {

    }

    func configureLayout() {

    }

    func configureView() {
        backgroundColor = .systemBackground
    }
}
