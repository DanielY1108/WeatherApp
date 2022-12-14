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
        "let's get started on weatherApp."
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
    private let view4 = TutorialView()

    
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
        
        let contentViews = [view1, view2, view3, view4]
        
        for x in 0...3 {
            scrollView.addSubview(contentViews[x])
            if x < 3 {
                contentViews[x].nextButton.setTitle("Skip", for: .normal)
                contentViews[x].imageView.image = UIImage(named: imageName[x])
            } else {
                contentViews[x].nextButton.setTitle("Start", for: .normal)
            }
            contentViews[x].nextButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            contentViews[x].mainLabel.text = textLabel[x]
            contentViews[x].snp.makeConstraints { make in
                make.top.bottom.equalTo(scrollView.safeAreaLayoutGuide)
                make.width.equalTo(scrollView)
                make.leading.equalTo(scrollView).offset(view.frame.size.width * CGFloat(x))
            }
        }
        scrollView.showsHorizontalScrollIndicator = false
        
    }
    private func configureUI() {
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    @objc func skipButtonTapped(_ sender: UIButton) {
        alertManager()
    }
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currnet = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(currnet), y: 0), animated: true)
    }
    private func alertManager() {
        let alert = UIAlertController(title: "Allow location", message: "Are you sure you want to allow location? You can change it in settings at any time.", preferredStyle: .actionSheet)
        let setting = UIAlertAction(title: "Setting", style: .default) { action in
            LocationManager.shared.setupLocationManager()
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Default", style: .cancel) { action in
            self.dismiss(animated: true)
            let location = CLLocationCoordinate2D()
            Task {
                await WeatherManager.shared.eachWeatherData(lat: location.latitude, lon: location.longitude, in: .mainViewController)
                self.dismiss(animated: true)
            }
        }
        alert.addAction(setting)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension TutorialController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
