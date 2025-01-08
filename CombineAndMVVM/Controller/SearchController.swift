////
////  SearchController.swift
////  CombineAndMVVM
////
////  Created by MacBook Pro on 2024/7/23.
////
//
//import UIKit
//
//class SearchController: UISearchController, UISearchBarDelegate {
//  
////  let searchController: UISearchController
//  weak var ownerViewController: UIViewController?
////  weak var delegate: UISearchBarDelegate?
//
//  init(searchResultsController: UIViewController?, ownerViewController: UIViewController) {
//    self.ownerViewController = ownerViewController
//            // 必須先初始化父類的 searchController
//            super.init(searchResultsController: searchResultsController)
//            configureSearchController() // 配置 searchController
//      }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}
//
//extension SearchController {
//  
//  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//      print("Cancel button clicked")
//      // 取消按鈕不應進行跳轉
//  }
//  
//  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//    print("Search bar tapped")
//  }
//  
//  private func configureSearchController() {
//    obscuresBackgroundDuringPresentation = false
//    searchBar.delegate = self
//    searchBar.placeholder = "Search..."
//    searchBar.layer.cornerRadius = 10
//    
//    
//  }
//}
