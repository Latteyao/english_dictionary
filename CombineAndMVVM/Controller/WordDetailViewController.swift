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
  
  private let bookmarkViewModel: BookmarkViewModel = .init()
  private let detailWordCollectionController: DetailWordCollectionController = .init()
  private let dataViewModel: DataViewModel?
  private var cancellables: Set<AnyCancellable> = []
  private var isBookmarked = false
  
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
    label.text = "❎"
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .systemGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let syllablesLabel: UILabel = {
    let label = UILabel()
    label.text = "❎"
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .systemGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let voiceButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  let separatorView: UIView = { // 分隔線
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Initializer

  init(viewModel: DataViewModel) {
    self.dataViewModel = viewModel
    super.init(themeViewModel: .init(themeManager: .shared))
    
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
    isBookmarked = bookmarkViewModel.check(title: dataViewModel?.viewData.word ?? "")
    configureUI()
//    setupLabelTextColor()
    configureConstraints() // 設定位置
    bindingViewModel()
  }
}

// MARK: - UI Configuration

extension WordDetailViewController {
  private func configureUI() {
    configureBackButton()
    configureBookmarkButton()
    configureButtonActions()
    setupViewHierarchy()
  }
  
  private func updateUI(with viewData: WordData) {
    mainWordLabel.text = viewData.word
    print("viewData.word: \(String(describing: viewData.word))") //FIX: Is nil
    syllablesLabel.text = viewData.syllables?.list.joined(separator: " ") ?? "".emptyOrNil()
    pronunciationLabel.text = viewData.pronunciation?.all ?? "".emptyOrNil()
    detailWordCollectionController.items = viewData.results ?? [] // 把 results 丟到 下方的 DetailViewController
  }
  
  private func configureBackButton() {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    backButton.setTitle("", for: .normal)
    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
            
    // Add a UIContextMenuInteraction to disable the long press menu
    let interaction = UIContextMenuInteraction(delegate: self)
    backButton.addInteraction(interaction)
            
    // Set the custom back button as the left bar button item
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
  
  private func configureBookmarkButton() {
    updateBookmarkButtonState()
  }
  
  private func setupLabelTextColor() {
//    mainWordLabel.textColor = ThemeManager.currentTextColor
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
    let bookmarkImage = UIImage(systemName: isBookmarked ? "bookmark" : "bookmark.fill")
    bookmarkButton.setImage(bookmarkImage, for: .normal)
    bookmarkButton.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
  }
}

extension WordDetailViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return nil // Return nil to disable the context menu
  }
}

extension WordDetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

// MARK: - Sub Button AddTarget

extension WordDetailViewController {
  private func configureButtonActions() {
    voiceButton.addTarget(self, action: #selector(speakButtonPressed), for: .touchUpInside)
  }
}

// MARK: - ViewModel Binding

extension WordDetailViewController {
  private func bindingViewModel() {
    bindViewData()
    bindErrorState()
  }
 
  private func bindViewData() {
    dataViewModel?.$viewData
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] viewData in
        guard let self = self else { return }
        self.updateUI(with: viewData)
      })
      .store(in: &cancellables)
  }
  
  private func bindErrorState() {
    dataViewModel?.$errorState
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] error in
        guard let self = self, let error = error else { return }
        self.showError(error.description)
      })
      .store(in: &cancellables)
  }
}

// MARK: - Button Action

extension WordDetailViewController {
  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func speakButtonPressed() {
    guard let dataViewModel = dataViewModel else { return }
    guard let word = dataViewModel.viewData.word else { return }
    let speechSynthesizer = AVSpeechSynthesizer()
    let speechUtterance = AVSpeechUtterance(string: word)
    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    speechSynthesizer.speak(speechUtterance)
  }
  
  @objc func bookmarkButtonPressed() {
    guard let dataViewModel = dataViewModel else { return }
    guard let word = dataViewModel.viewData.word else { return }
    if isBookmarked {
      bookmarkViewModel.addBookmark(title: word, wordData: dataViewModel.viewData)
    } else {
      bookmarkViewModel.deleteBookmark(title: word)
    }
    // 創建新的 UIBarButtonItem，並更新圖示
    isBookmarked.toggle()
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
      voiceButton.leadingAnchor.constraint(equalTo: pronunciationLabel.trailingAnchor, constant: 8)
    ])
  }
  
  private func setupSeparatorViewConstraints() {
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: pronunciationLabel.bottomAnchor, constant: 20),
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
