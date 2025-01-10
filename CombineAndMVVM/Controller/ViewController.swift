//
//  ViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/6/26.
//

import UIKit

class ViewController: BaseThemedViewController {
 
  
  // MARK: - Properties

  // FIX - 必須加入 Loading 的畫面 不然會提早點入會沒有資料
  private var dataViewModel: DataViewModel = .init()
  
  var searchController: UISearchController!

  var randomWordsCollectionView: RandomWordsCollectionView!

  var headerView: HeaderView!

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setViewModelCall() // 呼叫 ViewModel 隨機熱門單字
    viewModelCall() // 優先獲取所有熱門單字資料 ( 呼叫 ＡＰＩ 一次抓取 )
    configureUI() // 所有 View
    setupView()
    configureConstraints()
  }
}

// MARK: - ViewModel Interaction

extension ViewController {
  private func setViewModelCall() {
    dataViewModel.rollDice()
  }

  private func viewModelCall() {
//    Task { await dataViewModel.fetchAllpopularWords() }
    dataViewModel.fetchAllpopularWords()
  }
}

// MARK: - Search Bar Delegate Methods

extension ViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {}

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchResultsViewController = SearchResultsViewController(viewModel: dataViewModel)
    navigationController?.pushViewController(searchResultsViewController, animated: true)
    return true
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("Search button clicked!")
  }
}

// MARK: - UI Configuration

extension ViewController {
  
  private func configureUI() {
    configureHeaderView() // 設置抬頭 View
    configureSearchController() // 設置搜尋 Controller
    configureRandomWordsCollectionView() // 設置隨機單字的 CollectionView
  }
  
  private func setupView(){
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
    searchController = UISearchController(searchResultsController: SearchResultsViewController(viewModel: dataViewModel))
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
    randomWordsCollectionView.viewModel = dataViewModel
   
    /// Constraints
  }

  /// 測試從viewModel的getData function 獲取資料
}

// MARK: - Constraints

extension ViewController {
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

// MARK: - WordCollectionViewCellDelegate

extension ViewController: WordCollectionViewCellDelegate {
  /// 按下按鈕事件觸發後頁面轉Detail View
  func didTapWordButton(with word: String, in index: Int) {
    dataViewModel.newViewData(fallbackWord: word, form: dataViewModel.randomData[index])
    dataViewModel.errorState = dataViewModel.popularWordsErrorState[index]
    let wordDetailViewController = WordDetailViewController(viewModel: dataViewModel)
//    let transition = CATransition()
//    transition.type = .push  // 可以選擇其他效果：.push, .reveal 等
//            transition.subtype = .fromRight  // 設定過渡的方向
//            transition.duration = 0.3  // 動畫持續時間
//    transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
//    navigationController?.view.layer.add(transition, forKey: kCATransition)
            

    /// 轉換下一個畫面
    print("navigation push to \(wordDetailViewController)")
    navigationController?.pushViewController(wordDetailViewController, animated: true)
  }
}
