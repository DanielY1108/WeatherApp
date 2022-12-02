//
//  TutorialController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/30.
//

import UIKit
import SnapKit

class TutorialController: UIViewController {
    
    let textLabel = [
        "깔끔한 메인뷰 좌우로 스와이프하여 메뉴스크린을 열어보세요",
        "나의 리스트가 메뉴에도 손쉽게 접근할 수 있어요",
        "나의 리스트에서 검색하고 지역을 추가 및 삭제할 수 있어요",
        "검색한 날씨를 확인하고 추가 또는 취소를 하세요",
        "세팅에서 지역설정 및 날씨단위를 바꿀 수 있어요"
    ]
    let imageName = ["mainView.png", "menuView.png", "myListView.png", "subView.png", "settingView.png"]
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()
    private let scrollView = UIScrollView()
    private let view1 = TutorialView()
    private let view2 = TutorialView()
    private let view3 = TutorialView()
    private let view4 = TutorialView()
    private let view5 = TutorialView()
    
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
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        let contentViews = [view1, view2, view3, view4, view5]
        // 5개의 뷰 생성하고 스크롤 뷰에 올린다.
        
        for x in 0...4 {
            scrollView.addSubview(contentViews[x])
            if x < 4 {
                contentViews[x].nextButton.setTitle("skip", for: .normal)
            } else {
                contentViews[x].nextButton.setTitle("start", for: .normal)
            }
            contentViews[x].nextButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            contentViews[x].mainLabel.text = textLabel[x]
            contentViews[x].imageView.image = UIImage(named: imageName[x])
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
//        self.dismiss(animated: true)
                alertManager()
    }
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currnet = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(currnet), y: 0), animated: true)
    }
    private func alertManager() {
        let alert = UIAlertController(title: "위치 허용", message: "사용자 위치를 허용하시겠습니까?", preferredStyle: .actionSheet)
        let allow = UIAlertAction(title: "Allow", style: .default) { action in
            LocationManager.shared.setupLocationManager()
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            guard let defualtLocation = LocationManager.shared.defualtLocation else { return }
            WeatherManager.shared.getEachWeatherData(lat: defualtLocation.latitude, lon: defualtLocation.longitude, weatherVC: .subViewController) {
                self.dismiss(animated: true)
            }
        }
        alert.addAction(allow)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension TutorialController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView: PreviewProvider {
    static var previews: some View {
        TutorialController()
            .toPreview()
    }
}
#endif
