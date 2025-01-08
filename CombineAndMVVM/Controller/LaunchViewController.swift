//
//  LaunchViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/29.
//

import UIKit
import Combine

class LaunchViewController: UIViewController {
  
  var launchCompletion = PassthroughSubject<Void, Never>()
  
  var animationCompletion: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Launchimage")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    view.addSubview(imageView)
    configureConstraints()
    animation()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.launchCompletion.send()
            }
  }
  
}
extension LaunchViewController {
//  private func navigateToMainView() {
//    let mainVC = TabBarController()
//    let navController = UINavigationController(rootViewController: mainVC)
//    navController.modalTransitionStyle = .crossDissolve
//    navController.modalPresentationStyle = .fullScreen
//    
//    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            window.rootViewController = navController
//            window.makeKeyAndVisible()
//        }
//    
//  }
  
  private func animation(){
    let basicAnimation = CABasicAnimation(keyPath: "opacity")
    
    basicAnimation.duration = 2
   
    basicAnimation.fromValue = 0.5
    basicAnimation.toValue = 1
    basicAnimation.autoreverses = true
    basicAnimation.repeatCount = 2
    imageView.layer.add(basicAnimation, forKey: nil)
  }
}
extension LaunchViewController{
  private func configureConstraints(){
    setupImageViewConstraints()
  }
  
  private func setupImageViewConstraints(){
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: 15),
      imageView.heightAnchor.constraint(equalTo: view.heightAnchor,constant: 15)
    ])
  }
}
