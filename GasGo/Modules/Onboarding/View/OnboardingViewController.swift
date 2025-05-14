//
//  OnboardingViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 11.05.2025.
//
//

import UIKit
import SnapKit
import Lottie

final class OnboardingViewController: BaseViewController {
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    
    return collectionView
  }()
  
  private let pageControl = UIPageControl()
  private let continueButton = UIButton()
  
  private var currentIndex: Int = 0
  
  var presenter: OnboardingPresentation!
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
    setupUI()
  }
  
  @objc private func continueButtonTapped() {
    let nextIndex = currentIndex + 1
    if nextIndex < OnboardingType.allCases.count {
      currentIndex = nextIndex
      let indexPath = IndexPath(item: currentIndex, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      
      pageControl.currentPage = currentIndex
    } else {
      print("Onboarding completed")
    }
  }
}

extension OnboardingViewController: OnboardingView {
  func setupUI() {
    view.applyGradient(colors: [UIColor.systemBlue.withAlphaComponent(0.5).cgColor,UIColor.white.cgColor])
    view.addSubview(collectionView)
    view.addSubview(continueButton)
    view.addSubview(pageControl)
    
    setupCollectionView()
    setupContinueButton()
    setupPageControl()
    
    setupConstraints()
  }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return OnboardingType.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.onboardingCollectionViewCell.rawValue, for: indexPath) as? OnboardingCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let onboarding = OnboardingType.allCases[indexPath.item]
    cell.configure(with: onboarding.title, subtitle: "", animationName: onboarding.animationName)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
}

extension OnboardingViewController {
  private func setupConstraints() {
    continueButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.height.equalTo(52)
      make.leading.trailing.equalTo(view).inset(16)
    }
    
    pageControl.snp.makeConstraints { make in
      make.bottom.equalTo(continueButton.snp.top).offset(-50)
      make.centerX.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      make.leading.trailing.equalTo(view).inset(16)
      make.bottom.equalTo(pageControl.snp.top).offset(-16)
    }
  }
  
  private func setupCollectionView() {
    collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = .clear
  }
  
  private func setupContinueButton() {
    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    continueButton.backgroundColor = .black
    continueButton.tintColor = .white
    continueButton.titleLabel?.font = Styles.font(family: .outfit, weight: .semiBold, size: 22)
    continueButton.setTitle("Devam Et", for: .normal)
    continueButton.layer.cornerRadius = 26
  }
  
  private func setupPageControl() {
    pageControl.numberOfPages = OnboardingType.allCases.count
    pageControl.pageIndicatorTintColor = .black
    pageControl.currentPageIndicatorTintColor = .white
  }
}
