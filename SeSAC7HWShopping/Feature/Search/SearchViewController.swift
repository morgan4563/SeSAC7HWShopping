//
//  ViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/26/25.
//

import UIKit

final class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()

	let searchView = SearchView()

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    private func setupUI() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchView.searchBar.delegate = self
    }

    private func bind() {
        viewModel.outputTextValid.lazyBind { [weak self] result in
            guard let self else { return }
            guard result else {
                let alert = UIAlertController(title: "확인 필요", message: "두 글자 이상 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
                return
            }
            let vc = SearchResultViewController()
            print("check1 nextVC 생성됨")
            vc.viewModel.inputTitleText.value = self.viewModel.inputText
			print("check2 nextVC에 인풋(검색용)에 검색어 값넣음")
            self.navigationController?.pushViewController(vc, animated: true)
            print("check3 화면전환 이후")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputText = searchBar.text
        viewModel.searchButtonTapped.value = ()
    }
}
