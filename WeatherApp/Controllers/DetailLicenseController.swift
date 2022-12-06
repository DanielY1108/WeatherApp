//
//  DetailLicenseController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class DetailLicenseController: UIViewController {
    
    let detailView = DetailLicenseView()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        detailView.imageLogo.image = UIImage(named: "RealmLogo.png")
        detailView.mainInfo.text 
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(self.view)
            make.left.right.equalTo(self.view)
        }
    }
}


