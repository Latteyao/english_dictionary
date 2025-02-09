//
//  BookmarkViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/12.
//

import Combine
import Foundation
import UIKit

// 繼承自 BaseThemedViewController，用於顯示和管理書籤列表
class BookmarkViewController: BaseThemedViewController, ErrorDisplayable {
  // MARK: - Properties

  var dataViewModel: DataViewModel

  var bookmarkViewModel: BookmarkViewModel

  private var cancellables = Set<AnyCancellable>()

  var tableView: UITableView!

  // MARK: - Initializer

  /// 初始化 BookmarkViewController，注入所需的 ViewModel
  /// - Parameters:
  ///   - viewModel: DataViewModel 實例
  ///   - bookmarkViewModel: BookmarkViewModel 實例
  init(viewModel: DataViewModel, bookmarkViewModel: BookmarkViewModel) {
    self.dataViewModel = viewModel
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
    setupCoreDataErrorHandling()
    setupView()
    configureUI()
    setupConstraints()
    bindBookmarksToTableView()
  }
}

// MARK: - Bookmarks Binding

extension BookmarkViewController {
  /// 綁定書籤數據到表格視圖，監聽書籤變化並重新載入表格
  func bindBookmarksToTableView() {
    bookmarkViewModel.$bookmarks
      .receive(on: DispatchQueue.main) // 確保在主線程更新 UI
      .sink { [weak self] _ in
        self?.tableView.reloadData() // 重新載入表格數據
        print("TableView reloaded")
      }
      .store(in: &cancellables) // 儲存訂閱以管理其生命週期
  }
}

// MARK: - UI Configuration

extension BookmarkViewController {
  /// 配置 UI，將表格視圖添加到主視圖中
  private func configureUI() {
    view.addSubview(tableView)
  }

  /// 設置視圖的外觀和導航欄
  private func setupView() {
    navigationItem.title = "Bookmarks"
    navigationController?.navigationBar.prefersLargeTitles = true
    setupTableView()
  }

  /// 初始化和配置表格視圖
  private func setupTableView() {
    tableView = UITableView(frame: .zero, style: .plain) // 初始化
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension // 自動行高
    tableView.estimatedRowHeight = 44 // 估計高度
    tableView.register(BookmarkCellView.self, forCellReuseIdentifier: "bookmarkCell")
  }
  /// 設置 CoreDataRepository 的錯誤處理回調,和畫面的顯示
  private func setupCoreDataErrorHandling(){
    bookmarkViewModel.bookmarkManager.coreDataRepository.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(errorMessage) // 顯示錯誤訊息
            }
        }
  }
}

// MARK: - TableView Delegate Methods

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
  /// 設定表格視圖中每個 section 的行數
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - section: section 的索引
  /// - Returns: 行數
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookmarkViewModel.bookmarks.count
  }

  /// 配置表格視圖中的每個 Cell
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - indexPath: Cell 的位置
  /// - Returns: 配置好的 UITableViewCell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkCellView
    cell.configure(with: bookmarkViewModel.bookmarks[indexPath.row].title ?? "")
    return cell
  }

  /// 當使用者選擇某一行時呼叫的方法，觸發單詞的詳細信息抓取
  /// - Parameters:
  ///   - tableView: UITableView 實例
  ///   - indexPath: 被選中的 Cell 的位置
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = bookmarkViewModel.bookmarks[indexPath.row].data // 獲取選中的書籤數據
    if let data = data?.decode(WordData.self) { // 解碼數據為 WordData 類型
      dataViewModel.loadDataToDetailState(form: data) // 從 ViewModel 抓取單詞詳細信息
      let wordDetailViewController = WordDetailViewController(data: dataViewModel.detailState,
                                                              bookmark: bookmarkViewModel,
                                                              isbookmarked: bookmarkViewModel.isBookmarkExist(name: data.word ?? ""))
      wordDetailViewController.navigationItem.largeTitleDisplayMode = .never // 不使用大型標題
      wordDetailViewController.wordDetailDelegate = self // 設置代理
      tableView.deselectRow(at: indexPath, animated: true) // 取消選擇狀態
      print("navigation push to \(wordDetailViewController)")
      navigationController?.pushViewController(wordDetailViewController, animated: true) // 導航到詳細視圖
      dataViewModel.resetState() // 重置 detailState
    }
  }
}

// MARK: - Constraints

extension BookmarkViewController {
  /// 配置所有子視圖的約束
  private func setupConstraints() {
    setupTableViewConstraints() // 設置表格視圖的約束
  }
  
  /// 設置 tableView 的具體約束，確保其填滿視圖並有右側間距
  private func setupTableViewConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - WordDetailViewDelegate

extension BookmarkViewController: WordDetailViewDelegate {
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
