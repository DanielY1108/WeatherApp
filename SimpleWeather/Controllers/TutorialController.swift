//
//  TutorialController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/30.
//

import UIKit
import SnapKit
import CoreLocation

final class TutorialController: UIViewController {
    
    let textLabel = [
        "Swipe screen to open the menu. Get easy access to the weather.",
        "You can search and delete from My List.",
        "Change the location and unit in Settings.",
        "let's get started on Simple Weather."
    ]
    let imageName = ["menuView.png", "myListView.png", "settingView.png"]
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()
    private let scrollView = UIScrollView()
    private let view1 = TutorialView()
    private let view2 = TutorialView()
    private let view3 = TutorialView()
    private let allowLocationView = AllowLocationView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * 4, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        let contentViews = [view1, view2, view3]
        
        for x in 0...2 {
            scrollView.addSubview(contentViews[x])
            
            contentViews[x].nextButton.setTitle("Skip", for: .normal)
            contentViews[x].nextButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            contentViews[x].imageView.image = UIImage(named: imageName[x])
            contentViews[x].mainLabel.text = textLabel[x]
            
            contentViews[x].snp.makeConstraints {
                $0.top.bottom.equalTo(scrollView.safeAreaLayoutGuide)
                $0.width.equalTo(scrollView)
                $0.leading.equalTo(scrollView).offset(view.frame.size.width * CGFloat(x))
            }
        }
        // allow location notice
        scrollView.addSubview(allowLocationView)
        allowLocationView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.safeAreaLayoutGuide)
            $0.width.equalTo(scrollView)
            $0.leading.equalTo(scrollView).offset(view.frame.size.width * 3)
        }
        scrollView.showsHorizontalScrollIndicator = false
    }
    private func configureUI() {
        allowLocationView.delegate = self
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let currnet = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(currnet), y: 0), animated: true)
    }
    @objc private func skipButtonTapped(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * 3, y: 0), animated: false)
    }
}

extension TutorialController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

extension TutorialController: LocationViewButtonDelegate {
    func tappedContinue() {
        LocationManager.shared.setupLocationManager()
        self.dismiss(animated: true)
    }
}
