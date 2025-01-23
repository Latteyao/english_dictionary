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

  /// 搜尋Text
  var searchText: String? {
    didSet {
      if isViewLoaded {
        searchForText()
      }
    }
  }

  // MARK: - Initializer

  /// 初始化 SearchResultsViewController，注入所需的 ViewModel
  /// - Parameters:
  ///   - viewModel: DataViewModel 實例
  ///   - searchViewModel: SearchViewModel 實例，默認為新的 SearchViewModel
  ///   - bookmarkViewModel: BookmarkViewModel 實例
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
  /// 根據搜尋文字更新界面，顯示搜尋結果標籤
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
  /// 配置 UISearchController，設置代理和外觀
  private func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search..."
    definesPresentationContext = true
    navigationItem.searchController = searchController
  }

  /// 當搜尋結果更新時呼叫的方法，觸發搜尋操作並更新表格視圖
  /// - Parameter searchController: UISearchController 實例
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
    searchViewModel.search(query: query) { [weak self] in
      self?.resultsTableView.separatorStyle = .singleLine
      self?.resultsTableView.reloadData()
      self?.scrollToTop()
      print("results updated")
    }
  }

  /// 當使用者點擊取消按鈕時呼叫的方法，返回上一頁
  /// - Parameter searchBar: UISearchBar 實例
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    navigationController?.popViewController(animated: true)
    // 聚焦搜尋列
  }

  /// 當搜尋列即將開始編輯時呼叫的方法
  /// - Parameter searchBar: UISearchBar 實例
  /// - Returns: 是否允許開始編輯
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    print("Search bar clicked")
    return true
  }
}

// MARK: - UI Configuration

extension SearchResultsViewController {
  /// 配置 TableView，設置 dataSource 和  delegate ，並註冊自訂的 Cell
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
  /// 設定表格視圖中每個 section 的行數
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - section: section 的索引
  /// - Returns: 行數
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchViewModel.searchResults.results.data?.count ?? 0
  }

  /// 配置表格視圖中的每個 Cell
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - indexPath: Cell 的位置
  /// - Returns: 配置好的 UITableViewCell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkCellView
    cell.configure(with: searchViewModel.searchResults.results.data?[indexPath.row] ?? "")
    return cell
  }

  /// 當使用者選擇某一行時呼叫的方法，觸發單詞的詳細信息抓取
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - indexPath: 被選中的 Cell 的位置
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let resultdata = searchViewModel.searchResults.results.data?[indexPath.row] else { return }
    dataViewModel.fetchSingleWord(resultdata)
  }

  /// 滾動表格視圖到頂部
  private func scrollToTop() {
    resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
  }
}

// MARK: - Constraints

extension SearchResultsViewController {
  /// 配置所有子視圖的約束
  private func configureConstraints() {
    setupTableView()
  }

  /// 設置 resultsTableView 的具體約束
  private func setupTableView() {
    NSLayoutConstraint.activate([
      resultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
      resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
    ])
  }
}

// MARK: - WordDetailViewDelegate

extension SearchResultsViewController: WordDetailViewDelegate {
  /// 當使用者點擊書籤按鈕時呼叫的方法，根據當前狀態添加或刪除書籤
  /// - Parameters:
  ///   - title: 單詞的標題
  ///   - data: 單詞的詳細數據
  func wordDateilViewDidTapBookmarkbutton(_ title: String, data: WordData) {
    let isBookmarked: Bool = bookmarkViewModel.isBookmarkExist(name: title)
    if isBookmarked {
      bookmarkViewModel.deleteBookmark(name: title)
    } else {
      bookmarkViewModel.addBookmark(name: title, data: data)
    }
  }
}

// MARK: - DataViewModel Bindings

extension SearchResultsViewController {
  /// 設置 Combine 的綁定，監聽 DataViewModel 的 detailState 變化並導航到詳細視圖
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
