//
//  TutorialView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/01.
//

import UIKit

class TutorialView: UIView {

    let mainLabel: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 22, weight: .black)
        lable.numberOfLines = 0
        lable.textAlignment = .center
        lable.textColor = .defaultLabelColor
        return lable
    }()
    let nextButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    let imageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
    }
}
// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView2: PreviewProvider {
    static var previews: some View {
        TutorialController()
            .toPreview()
    }
}
#endif
