//
//  ViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/26/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    let mainContainerView = UIView()
    let titleStackView = UIStackView()
    let	titleImage = UIImageView()
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureLayout()
        configureView()
    }


}

extension SearchViewController: ViewDesignProtocol {
    func configureHierachy() {
        view.addSubview(searchBar)
        view.addSubview(titleStackView)
        view.addSubview(mainContainerView)
        mainContainerView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleImage)
        titleStackView.addArrangedSubview(titleLabel)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    func configureView() {
        view.backgroundColor = .systemBackground
        title = "영캠러의 쇼핑쇼핑"
        navigationController?.navigationBar.tintColor = .label

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        titleImage.contentMode = .scaleAspectFit
        titleImage.image = UIImage(named: "noMoneyMan")

        titleStackView.alignment = .center
        titleStackView.axis = .vertical

        titleLabel.text = "쇼핑하구팡"
        titleLabel.textColor = .label

    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count >= 2 else {
            let alert = UIAlertController(title: "확인 필요", message: "두 글자 이상 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        let vc = SearchResultViewController()
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
    }
}
