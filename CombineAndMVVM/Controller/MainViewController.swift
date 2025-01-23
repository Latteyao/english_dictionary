//
//  MainViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/6/26.
//

import UIKit
import Combine

class MainViewController: BaseThemedViewController {
  // MARK: - Properties

  // FIX - 必須加入 Loading 的畫面 不然會提早點入會沒有資料
  private var dataViewModel: DataViewModel
  
  private var bookmarkViewModel: BookmarkViewModel

  private var searchController: UISearchController!

  var randomWordsCollectionView: RandomWordsCollectionView!
  
  private var cancellables = Set<AnyCancellable>()

  private var headerView: HeaderView!
  
  
  
  

  init(viewModel: DataViewModel, bookmarkViewModel: BookmarkViewModel) {
    self.dataViewModel = viewModel
    self.bookmarkViewModel = bookmarkViewModel
    super.init()
  }
  
   required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  @available(*, unavailable)
//  @MainActor required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI() // 所有 View
    setupView()
    configureConstraints()
    setupBindings()
  }
}

extension MainViewController{
  private func setupBindings() {
          dataViewModel.$randomData
              .receive(on: DispatchQueue.main)
              .sink { [weak self] _ in
                self?.randomWordsCollectionView.collectionView.reloadData()
              }
              .store(in: &cancellables)
          
          // 如果有其他需要綁定的屬性，可以在這裡添加
      }
}


// MARK: - Search Bar Delegate Methods

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {}

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchResultsViewController = SearchResultsViewController(viewModel: dataViewModel, bookmarkViewModel: bookmarkViewModel)
    navigationController?.pushViewController(searchResultsViewController, animated: true)
    return true
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("Search button clicked!")
  }
}

// MARK: - UI Configuration

extension MainViewController {
  private func configureUI() {
    configureHeaderView() // 設置抬頭 View
    configureSearchController() // 設置搜尋 Controller
    configureRandomWordsCollectionView() // 設置隨機單字的 CollectionView
  }

  private func setupView() {
    view.addSubview(headerView)
    view.addSubview(searchController.searchBar)
    view.addSubview(randomWordsCollectionView)
  }

  /// Header UI Setting
  private func configureHeaderView() {
    headerView = HeaderView(frame: .zero)
    headerView.translatesAutoresizingMaskIntoConstraints = false
  }

  /// Seach Controller
  private func configureSearchController() {
    searchController = UISearchController(searchResultsController: SearchResultsViewController(viewModel: dataViewModel, bookmarkViewModel: bookmarkViewModel))
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.searchTextField.leftView?.tintColor = .black
    searchController.searchBar.placeholder = "Search..."
    searchController.searchBar.barStyle = .black
    searchController.searchBar.searchTextField.backgroundColor = .white
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  /// 設置隨機顯示Word的CollectionView
  private func configureRandomWordsCollectionView() {
    /// 設定RandomWordsCollectionView的frame
    randomWordsCollectionView = RandomWordsCollectionView()
    /// delegate
    randomWordsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    randomWordsCollectionView.delegate = self
    randomWordsCollectionView.collectionView.dataSource = self
    randomWordsCollectionView.collectionView.delegate = self
  }
}

// MARK: - Constraints

extension MainViewController {
  /// 相對位置設定
  private func configureConstraints() {
    setupRandomWordsCollectionViewConstraints()
    setupHeaderViewConstraints()
  }

  private func setupRandomWordsCollectionViewConstraints() {
    NSLayoutConstraint.activate([
      randomWordsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      randomWordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
      randomWordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
      randomWordsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3), // 根據需要調整高度
    ])
  }

  private func setupHeaderViewConstraints() {
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.165),
    ])
  }
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataViewModel.randomData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCollectionViewCell
    cell.configure(with: dataViewModel.randomData[indexPath.item].word)
    cell.delegate = self
    return cell
  }
  
  
}

// MARK: - WordCollectionViewCellDelegate

extension MainViewController: WordCollectionViewCellDelegate {
  func didTapReroll() {
    dataViewModel.reloadPopularWords()
  }
  
  /// 按下按鈕事件觸發後頁面轉Detail View
  func didTapWordButton(in cell: WordCollectionViewCell) {
    
    guard let indexPath = randomWordsCollectionView.collectionView.indexPath(for: cell) else { return }
    dataViewModel.loadRandomDataToDetailState(form: dataViewModel.randomData[indexPath.item])
    let wordDetailViewController = WordDetailViewController(data: dataViewModel.detailState,
                                                            isbookmarked: self.bookmarkViewModel.isBookmarkExist(name: dataViewModel.randomData[indexPath.item].word))
    wordDetailViewController.wordDetailDelegate = self
//    let transition = CATransition()
//    transition.type = .push  // 可以選擇其他效果：.push, .reveal 等
//            transition.subtype = .fromRight  // 設定過渡的方向
//            transition.duration = 0.3  // 動畫持續時間
//    transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
//    navigationController?.view.layer.add(transition, forKey: kCATransition)

    /// 轉換下一個畫面
    print("navigation push to \(wordDetailViewController)")
    navigationController?.pushViewController(wordDetailViewController, animated: true)
    // 重置 detailState 以防止重複導航
    dataViewModel.resetState()
  }
}


extension MainViewController: WordDetailViewDelegate {
  func wordDateilViewDidTapBookmarkbutton(_ title: String, data: WordData) {
    let isBookmarked: Bool = bookmarkViewModel.isBookmarkExist(name: title)
    if isBookmarked {
      bookmarkViewModel.deleteBookmark(name: title)
    } else {
      bookmarkViewModel.addBookmark(name: title, data: data)
    }
  }
}
