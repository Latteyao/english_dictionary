//
//  DetailWordCollectionController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/8/2.
//

import Foundation
import UIKit
/// 控制每個DetailWordCollectionCellView的DetailWordCollection
class DetailWordCollectionController: UICollectionView {
  
  // MARK: - Properties
  var expandedIndexPaths = [IndexPath: Bool]()
  
  var items: [WordResult]
  
  // MARK: - Initializer
  
  init(items: [WordResult]) {
    self.items = items
    let layout = UICollectionViewFlowLayout()
    super.init(frame: .zero, collectionViewLayout: layout)
    self.delegate = self
    self.dataSource = self
    self.backgroundColor = .clear // 背景色
    register(DetailWordCollectionCellView.self, forCellWithReuseIdentifier: "DetailWordCollectionCell")
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


//MARK: - CollectionView Delegate Methods

extension DetailWordCollectionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailWordCollectionCell", for: indexPath) as! DetailWordCollectionCellView
    // 資料傳輸
    cell.configure(with: items[indexPath.item])
    /// 展開狀態
    let isExpanded = expandedIndexPaths[indexPath] ?? false
    cell.vstackView.isHidden = !isExpanded
    /// 更新 chevronButton 旋轉角度
    let rotationAngleL: CGFloat = isExpanded ? 1.6 : 0 // 展開時旋轉 180 度
    UIView.animate(withDuration: 0.3) {
      cell.chevronButton.transform = CGAffineTransform(rotationAngle: rotationAngleL)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 切換當前 cell 的展開狀態
    // 初始化狀態
    let isCurrentlyExpanded = expandedIndexPaths[indexPath] ?? false
    expandedIndexPaths[indexPath] = !isCurrentlyExpanded
    //控制單一 Cell 開關動畫顯示
    if let cell = collectionView.cellForItem(at: indexPath) as? DetailWordCollectionCellView {
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
        cell.updateChevronDirection(isExpanded: !isCurrentlyExpanded)
            collectionView.performBatchUpdates {
          collectionView.reloadItems(at: [indexPath])
          }
        }, completion: nil)
    }
    //開關顯示通知
    guard expandedIndexPaths[indexPath] == true else {
      print("👉  Close  Index: \(indexPath.row) 👈")
      return
    }
    print("👉  Open  Index: \(indexPath.row)  👈")
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    /// 展開狀態
    let isExpanded = expandedIndexPaths[indexPath] ?? false
    ///目標寬度
    let targetWidth = collectionView.frame.width - 16
    // 如果 cell 展開，計算展開後的高度
    if isExpanded {
      let cell = DetailWordCollectionCellView()
      cell.configure(with: items[indexPath.item])
      ///目標寬高
      let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
      let fittingSize = cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .dragThatCanResizeScene)
      print("-----------------------------------------------------------------------")
      print("Fitting size: \(fittingSize) for indexPath: \(indexPath.row + 1)", "indexPath Bool: \(expandedIndexPaths[indexPath] ?? false)")
      print("-----------------------------------------------------------------------")
      return CGSize(width: targetWidth, height: fittingSize.height + 60) // 展開後的寬度跟高度
    }
    return CGSize(width: targetWidth, height: 80) // 未展開的寬度跟固定高度
  }
}
