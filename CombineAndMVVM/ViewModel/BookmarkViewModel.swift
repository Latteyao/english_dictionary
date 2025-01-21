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
  
  private let bookmarkManager: BookmarkService
  
  
  // MARK: - Initializer
  init (bookmarkManager: BookmarkService = BookmarkManager()) {
    self.bookmarkManager = bookmarkManager
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

  func addBookmark(name: String,data wordData: WordData) {
    let encodedData = Data.encode(wordData) ?? Data()
    bookmarkManager.saveBookmark(title: name, data: encodedData)
    fetchBookmarks() // 更新 UI
  }

  func deleteBookmark(name: String) {
    bookmarkManager.delete(title: name)
    fetchBookmarks() // 更新 UI
  }

  func isBookmarkExist(name: String) -> Bool {
    return bookmarkManager.isBookmarkDuplicate(name)
  }
}
