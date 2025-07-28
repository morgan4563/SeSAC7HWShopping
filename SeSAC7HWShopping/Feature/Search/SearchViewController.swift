//
//  ViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/26/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
	let searchView = SearchView()

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.tintColor = .label
        title = "영캠러의 쇼핑쇼핑"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchView.searchBar.delegate = self
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
