//
//  LaunchViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/29.
//

import Combine
import UIKit

// 自訂的 LaunchViewController，用於應用啟動時的展示畫面
class LaunchViewController: UIViewController {
  // MARK: - Properties
  
  var launchCompletion = PassthroughSubject<Void, Never>()
  
  var animationCompletion: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  /// 顯示啟動畫面的 ImageView
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Launchimage")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black // 設定背景顏色為黑色
    view.addSubview(imageView) // 將圖片視圖添加到主視圖中
    configureConstraints() // 設置圖片視圖的約束
    animation() // 啟動動畫
    // 延遲3秒後發送啟動完成的信號
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.launchCompletion.send()
    }
  }
}

// MARK: - Animation and Navigation

extension LaunchViewController {
  /// 設置並啟動圖片視圖的動畫效果
  private func animation() {
    let basicAnimation = CABasicAnimation(keyPath: "opacity") // 創建一個基本動畫，修改不透明度
    basicAnimation.duration = 2 // 設定動畫持續時間
    basicAnimation.fromValue = 0.5 // 動畫開始時的透明度
    basicAnimation.toValue = 1 // 動畫結束時的透明度
    basicAnimation.autoreverses = true // 動畫完成後自動反轉
    basicAnimation.repeatCount = 2 // 動畫重複次數
    imageView.layer.add(basicAnimation, forKey: nil) // 將動畫添加到圖片視圖的圖層上
  }
}

// MARK: - Constraints

extension LaunchViewController {
  
  /// 配置所有子視圖的約束
  private func configureConstraints() {
    setupImageViewConstraints() // 設置圖片視圖的約束
  }
  
  /// 設置 imageView 的具體約束
  private func setupImageViewConstraints() {
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 15),
      imageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 15)
    ])
  }
}
