//
//  BookmarkViewModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/5.
//

import Combine
import Foundation

class BookmarkViewModel: ObservableObject {
  // MARK: - Properties
  
  @Published var bookmarks: [Bookmark] = []
  private let bookmarkManager = BookmarkManager.shared
  
  // MARK: - Initializer
  
  init() {
    DispatchQueue.main.async {
      self.fetchBookmarks()
    }
  }
}

// MARK: - Methods

extension BookmarkViewModel {
  func fetchBookmarks() {
    let fetchedBookmarks = bookmarkManager.fetchBookmarks()
    DispatchQueue.main.async {
      self.bookmarks = fetchedBookmarks
      print("Fetched bookmarks: \(self.bookmarks.count)") // 确认数据加载数量
    }
  }

  func addBookmark(title: String, wordData: WordData) {
    let encodedData = Data.encode(wordData) ?? Data()
    bookmarkManager.save(title: title, data: encodedData)
    fetchBookmarks() // 更新 UI
  }

  func deleteBookmark(title: String) {
    bookmarkManager.delete(title: title)
    fetchBookmarks() // 更新 UI
  }

  func check(title: String) -> Bool {
    return bookmarkManager.isBookmarkDuplicate(title)
  }
}
