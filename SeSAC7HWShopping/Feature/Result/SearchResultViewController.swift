//
//  SearchResultViewController.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 7/27/25.
//

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController {
    let viewModel = SearchResultViewModel()
    let searchResultView = SearchResultView()

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()

        //버튼 세팅
        searchResultView.filterButtonsStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(self, action: #selector(filterButtonClicked(_:)), for: .touchUpInside)
            }
        }
        print("check4 nextVC 뷰디드로드댐")
    }

    private func bind() {
        viewModel.outputTitleText.bind { [weak self] _ in
            guard let self else { return }
            self.navigationItem.title = self.viewModel.outputTitleText.value
            guard !self.viewModel.outputTitleText.value.isEmpty else { return }
            self.viewModel.searchTrigger.value = ()
            print("check5 아웃풋 바인딩")
        }

        viewModel.outputSearchCountText.bind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchResultCountLabel.text = viewModel.outputSearchCountText.value
        }

        viewModel.loading.lazyBind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchItemCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }

        viewModel.errorPresent.lazyBind { [weak self] message in
            guard let self else { return }
            guard let message, !message.isEmpty else { return }
            let alert = UIAlertController(title: "네트워크 에러", message: message, preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) {_ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(confirm)
            present(alert, animated: true)
        }

        viewModel.list.bind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchItemCollection.reloadData()
        }

        viewModel.recommendList.bind { [weak self] _ in
            guard let self else { return }
            searchResultView.searchRecommendCollection.reloadData()
        }
    }

    private func configureCollectionView() {
        searchResultView.searchItemCollection.delegate = self
        searchResultView.searchItemCollection.dataSource = self
        searchResultView.searchItemCollection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)

        searchResultView.searchRecommendCollection.delegate = self
        searchResultView.searchRecommendCollection.dataSource = self
        searchResultView.searchRecommendCollection.register(SearchResultRecommendCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultRecommendCollectionViewCell.identifier)
    }

    @objc func filterButtonClicked(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        viewModel.sortKeyword = title
        viewModel.filterButtonClicked.value = ()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchResultView.searchItemCollection {
            return viewModel.list.value.items.count
        } else {
            return viewModel.recommendList.value.items.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchResultView.searchItemCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
                return UICollectionViewCell()
            }

            let item = viewModel.list.value.items[indexPath.item]
            if let imageURL = URL(string: item.image) {
                cell.imageView.kf.setImage(with: imageURL)
            }
            cell.mallLabel.text = item.mallName
            cell.titleLabel.text = item.title.tagDeleted

            if let price = Int(item.lprice) {
                let decimalPrice = PriceFormatter.shared.formatter.string(for: price)
                cell.priceLabel.text = decimalPrice
            } else {
                cell.priceLabel.text = item.lprice
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultRecommendCollectionViewCell.identifier, for: indexPath) as? SearchResultRecommendCollectionViewCell else {
                return UICollectionViewCell()
            }

            let item = viewModel.recommendList.value.items[indexPath.item]
            if let imageURL = URL(string: item.image) {
                cell.imageView.kf.setImage(with: imageURL)
            }

            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.isEnd == false && indexPath.item == viewModel.list.value.items.count - 3 {
            viewModel.start += Int(viewModel.displayCountString)!
        }
    }
}
