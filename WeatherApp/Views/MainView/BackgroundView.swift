//
//  BackgroundView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/15.
//

import UIKit
import SnapKit

final class BackgroundView: UIView {

    private let backgruondImg = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgruondImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureImage()        
    }
    
    private func configureImage() {
        backgruondImg.image = UIImage(named: "background.svg")
        backgruondImg.contentMode = .scaleAspectFit
        backgruondImg.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
