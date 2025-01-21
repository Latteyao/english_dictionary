//
//  BookmarkViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/12.
//

import Combine
import Foundation
import UIKit

class BookmarkViewController: BaseThemedViewController {
  // MARK: - Properties
  
  var dataViewModel: DataViewModel
  
  var bookmarkViewModel: BookmarkViewModel
  
  private var cancellables = Set<AnyCancellable>()
  
  var tableView: UITableView!
  
  init(viewModel: DataViewModel, bookmarkViewModel: BookmarkViewModel){
    self.dataViewModel = viewModel
    self.bookmarkViewModel = bookmarkViewModel
    super.init()
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    configureUI()
    
    setupConstraints()
    bindBookmarksToTableView()
  }
}

// MARK: - Bookmarks Binding

extension BookmarkViewController {
  func bindBookmarksToTableView() {
    bookmarkViewModel.$bookmarks
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
        print("TableView reloaded")
      }
      .store(in: &cancellables)
  }
}

// MARK: - UI Configuration

extension BookmarkViewController {
  private func configureUI() {
    view.addSubview(tableView)
  }
  
  private func setupView() {
    navigationItem.title = "Bookmarks"
    navigationController?.navigationBar.prefersLargeTitles = true
    setupTableView()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: .zero, style: .plain) // 初始化
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension // 自動行高
    tableView.estimatedRowHeight = 44 // 估計高度
    tableView.register(BookmarkCellView.self, forCellReuseIdentifier: "bookmarkCell")
  }
}

// MARK: - TableView Delegate Methods

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookmarkViewModel.bookmarks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkCellView
    
    cell.configure(with: bookmarkViewModel.bookmarks[indexPath.row].title ?? "")
    
    // 配置 cell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // FIX : 這裡的資料要設定好 可以參考ViewController 的 didTapWordButton func 的寫法
    let data = bookmarkViewModel.bookmarks[indexPath.row].data
    if let data = data?.decode(WordData.self) {
      dataViewModel.loadDataToDetailState(form: data)
//      dataViewModel.detailState.wordData = data
//      dataViewModel.viewData = data
//      let word = dataViewModel.detailState.data.word ?? ""
      let wordDetailViewController = WordDetailViewController(data: dataViewModel.detailState, isbookmarked: bookmarkViewModel.isBookmarkExist(name: data.word ?? ""))
      wordDetailViewController.navigationItem.largeTitleDisplayMode = .never
      // 按下去動畫
      tableView.deselectRow(at: indexPath, animated: true)
      print("navigation push to \(wordDetailViewController)")
      navigationController?.pushViewController(wordDetailViewController, animated: true)
    }
  }
}

// MARK: - Constraints

extension BookmarkViewController {
  private func setupConstraints() {
    setupTableViewConstraints()
  }

  private func setupTableViewConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
