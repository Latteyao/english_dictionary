//
//  SearchResultsViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/11.
//

import Combine
import Foundation
import UIKit

class SearchResultsViewController: BaseThemedViewController {
  // MARK: - Properties

  var searchController: UISearchController!

  var resultsTableView: UITableView!

  var searchViewModel: SearchViewModel

  private var dataViewModel: DataViewModel

  private var bookmarkViewModel: BookmarkViewModel

  var cancellables: Set<AnyCancellable> = []

  // MARK: - Initializer

  init(
    viewModel: DataViewModel,
    searchViewModel: SearchViewModel = SearchViewModel(),
    bookmarkViewModel: BookmarkViewModel
  ) {
    self.dataViewModel = viewModel
    self.searchViewModel = searchViewModel
    self.bookmarkViewModel = bookmarkViewModel
    super.init()
  }

  @available(*, unavailable)
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.setHidesBackButton(true, animated: true)
    searchForText()
    configureSearchController()
    configureTableView()
    configureConstraints()
    setupBindings() // 設置訂閱
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.searchController.searchBar.becomeFirstResponder()
    }
  }
}

// MARK: - UI Configuration

extension SearchResultsViewController {
  private func searchForText() {
    guard let searchText = searchText else { return }
    let label = UILabel()
    label.text = "搜尋結果：\(searchText)"
    label.textAlignment = .center
    label.frame = view.bounds
    view.addSubview(label)
  }
}

// MARK: - SearchController

extension SearchResultsViewController: UISearchResultsUpdating, UISearchBarDelegate {
  private func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search..."
    definesPresentationContext = true
    navigationItem.searchController = searchController
  }

  func updateSearchResults(for searchController: UISearchController) {
//    print(searchController.searchBar.text  ?? "")
    guard let query = searchController.searchBar.text else { return }
    searchViewModel.search(query: query) { [weak self] in

//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self?.resultsTableView.separatorStyle = .singleLine
      self?.resultsTableView.reloadData()
      self?.scrollToTop()
      print("results updated")
//      }
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    navigationController?.popViewController(animated: true)
    // 聚焦搜尋列
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    print("Search bar clicked")
    return true
  }
}

// MARK: - UI Configuration

extension SearchResultsViewController {
  func configureTableView() {
    resultsTableView = UITableView()
    resultsTableView.dataSource = self
    resultsTableView.delegate = self
    resultsTableView.translatesAutoresizingMaskIntoConstraints = false
    resultsTableView.tableFooterView = UIView() // 沒有資料的cell欄位隱藏分隔線
    resultsTableView.separatorStyle = .none
    resultsTableView.register(BookmarkCellView.self, forCellReuseIdentifier: "bookmarkCell")

    view.addSubview(resultsTableView)
  }
}

// MARK: - TableView Delegate Methods

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchViewModel.searchResults.results.data?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkCellView

    cell.configure(with: searchViewModel.searchResults.results.data?[indexPath.row] ?? "")
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let resultdata = searchViewModel.searchResults.results.data?[indexPath.row] else { return }
    dataViewModel.fetchSingleWord(resultdata)
  }

  private func scrollToTop() {
    resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
  }
}

// MARK: - Constraints

extension SearchResultsViewController {
  private func configureConstraints() {
    setupTableView()
  }

  private func setupTableView() {
    NSLayoutConstraint.activate([
      resultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
      resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
    ])
  }
}

extension SearchResultsViewController: WordDetailViewDelegate {
  func wordDateilViewDidTapBookmarkbutton(_ title: String, data: WordData) {
    let isBookmarked: Bool = bookmarkViewModel.isBookmarkExist(name: title)
    if isBookmarked {
      bookmarkViewModel.deleteBookmark(name: title)
    } else {
      bookmarkViewModel.addBookmark(name: title, data: data)
    }
  }
}

// MARK: - Bindings

extension SearchResultsViewController {
  private func setupBindings() {
    dataViewModel.$detailState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] data in
        guard let self = self else { return }
        guard let word = data.wordData.word, !word.isEmpty else {
          print("Data is empty or invalid, not navigating")
          return
        }
        let wordDetailVC = WordDetailViewController(
          data: data,
          bookmark: bookmarkViewModel,
          isbookmarked: self.bookmarkViewModel.isBookmarkExist(name: word)
        )
        wordDetailVC.wordDetailDelegate = self
        print("navigation push to \(wordDetailVC)")
        self.navigationController?.pushViewController(wordDetailVC, animated: true)
        // 重置 detailState 以防止重複導航
        dataViewModel.resetState()
      }
      .store(in: &cancellables)
  }
}
