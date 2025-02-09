//
//  WordDetailViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/12.
//

import AVFoundation
import Combine
import UIKit

/// 單字詳細資訊頁面
class WordDetailViewController: BaseThemedViewController, ErrorDisplayable {
  
  // MARK: - Properties
  
  private let bookmarkViewModel: BookmarkViewModel
  private let detailWordCollectionController: DetailWordCollectionController
  private var isBookmarked: Bool
  private let data: WordDetailState
  weak var wordDetailDelegate: WordDetailViewDelegate?
  
  // MARK: - UI Elements
  
  let mainWordLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 40)
    label.textColor = .brown
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var pronunciationLabel: UILabel = {
    let label = UILabel()
    label.text = "N/A"
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .systemGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let syllablesLabel: UILabel = {
    let label = UILabel()
    label.text = "N/A"
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .systemGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var voiceButton: UIButton!
  
  let separatorView: UIView = { // 分隔線
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Initializer

  init(data: WordDetailState,
       bookmark: BookmarkViewModel ,
       isbookmarked: Bool) {
    self.data = data
    self.bookmarkViewModel = bookmark
    self.isBookmarked = isbookmarked
    self.detailWordCollectionController = .init(items: data.wordData.results ?? [])
    super.init()
  }
  
  deinit {
    print("WordDetailView deinit it !!!")
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI(with: data.wordData)
    configureUI()
//    setupLabelTextColor()
    showError(data.error)
    configureConstraints() // 設定位置
  }
}

// MARK: - UI Configuration

extension WordDetailViewController {
  private func configureUI() {
    configureBackButton()
    configureBookmarkButton()
    configureVoiceButton()
    setupViewHierarchy()
  }
  
  private func updateUI(with viewData: WordData) {
    mainWordLabel.text = viewData.word
        
        // 更新音節標籤，若無音節則顯示佔位符
        if let syllables = viewData.syllables?.list, !syllables.isEmpty {
            syllablesLabel.text = syllables.joined(separator: " ")
        } else {
            syllablesLabel.text = "N/A"
        }
        
        // 更新發音標籤，若無發音則顯示佔位符
        if let pronunciation = viewData.pronunciation?.all, !pronunciation.isEmpty {
            pronunciationLabel.text = pronunciation
        } else {
            pronunciationLabel.text = "N/A"
        }
        
        // 更新詳細單字集合控制器的項目
        detailWordCollectionController.items = viewData.results ?? []
  }
  
  private func configureBackButton() {
    let backButton = UIButton(type: .system)
    let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    backButton.setImage(UIImage(systemName: "chevron.backward",withConfiguration: config), for: .normal)
    backButton.setTitle("", for: .normal)
    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
   
            
    // Add a UIContextMenuInteraction to disable the long press menu
    let interaction = UIContextMenuInteraction(delegate: self)
    backButton.addInteraction(interaction)
            
    // Set the custom back button as the left bar button item
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  private func configureBookmarkButton() {
    updateBookmarkButtonState()
  }
  
  private func setupLabelTextColor() {
//    mainWordLabel.textColor = self.themeViewModel.currentTextColor
  }
  
  private func setupViewHierarchy() {
    view.addSubview(mainWordLabel)
    view.addSubview(syllablesLabel)
    view.addSubview(pronunciationLabel)
    view.addSubview(voiceButton)
    view.addSubview(separatorView)
    view.addSubview(detailWordCollectionController)
  }
  
  private func updateBookmarkButtonState() {
    let bookmarkButton = UIButton(type: .system)
    let bookmarkImage = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    bookmarkButton.setImage(bookmarkImage, for: .normal)
    bookmarkButton.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
  }
  
  private func configureVoiceButton(){
    voiceButton = UIButton(type: .system)
    voiceButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
    voiceButton.translatesAutoresizingMaskIntoConstraints = false
    configureVoiceButtonActions()
  }
}

extension WordDetailViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return nil // Return nil to disable the context menu
  }
}

extension WordDetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    print("gestureRecognizerShouldBegin 被呼叫")
    return true
  }
}

// MARK: - Sub Button AddTarget

extension WordDetailViewController {
  private func configureVoiceButtonActions() {
    // 假如沒有 pronunciation 不會有聲音
    voiceButton.addTarget(self, action: #selector(speakButtonPressed), for: .touchUpInside)
  }
}

// MARK: - Button Action

extension WordDetailViewController {
  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func speakButtonPressed() {
    guard let word = data.wordData.word else { return }
    let speechSynthesizer = AVSpeechSynthesizer()
    let speechUtterance = AVSpeechUtterance(string: word)
    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    speechSynthesizer.speak(speechUtterance)
  }
  
  @objc func bookmarkButtonPressed() {
    guard let title = data.wordData.word else { return }
    print("is nil \(wordDetailDelegate == nil)")
    wordDetailDelegate?.wordDateilViewDidTapBookmarkbutton(title, data: data.wordData)
    // 創建新的 UIBarButtonItem，並更新圖示
    isBookmarked.toggle()
    print("isBookmarked: \(isBookmarked)")
    updateBookmarkButtonState()
  }
}

// MARK: - ConfigureConstraints

extension WordDetailViewController {
  private func configureConstraints() {
    setupMainWordLabelConstraints()
    setupSyllablesLabellConstraints()
    setupPronunciationLabelConstraints()
    setupSeparatorViewConstraints()
    setupDetailWordCollectionControllerConstraints()
    setupVoiceButtonConstraints()
  }
  
  private func setupMainWordLabelConstraints() {
    NSLayoutConstraint.activate([
      mainWordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainWordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
    ])
  }
                               
  private func setupSyllablesLabellConstraints() {
    NSLayoutConstraint.activate([
      syllablesLabel.topAnchor.constraint(equalTo: mainWordLabel.bottomAnchor, constant: 12),
      syllablesLabel.leadingAnchor.constraint(equalTo: mainWordLabel.leadingAnchor)
    ])
  }

  private func setupPronunciationLabelConstraints() {
    NSLayoutConstraint.activate([
      pronunciationLabel.topAnchor.constraint(equalTo: syllablesLabel.bottomAnchor, constant: 8),
      pronunciationLabel.leadingAnchor.constraint(equalTo: mainWordLabel.leadingAnchor)
    ])
  }
  
  private func setupVoiceButtonConstraints() {
    NSLayoutConstraint.activate([
      voiceButton.topAnchor.constraint(equalTo: pronunciationLabel.topAnchor, constant: 4),
      voiceButton.leadingAnchor.constraint(equalTo: pronunciationLabel.trailingAnchor, constant: 16)
    ])
  }
  
  private func setupSeparatorViewConstraints() {
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: voiceButton.bottomAnchor, constant: 20),
      separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  private func setupDetailWordCollectionControllerConstraints() {
    detailWordCollectionController.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      detailWordCollectionController.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
      detailWordCollectionController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      detailWordCollectionController.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      detailWordCollectionController.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
