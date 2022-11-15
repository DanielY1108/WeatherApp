//
//  Utilities.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/15.
//

import UIKit

enum ImageName {
    case user
    case system
}

// HeaderView Setting
struct Utilities {
    func configLabel(font: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: font, weight: weight)
        label.textColor = .black
        return label
    }
    
    func configImange(name: String, of: ImageName) -> UIImageView {
        let view = UIImageView()
        switch of {
        case .user:
            view.image = UIImage(named: name)
        case .system:
            view.image = UIImage(systemName: name)
        }
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func configStackView(_ stacks: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: stacks)
        stack.spacing = 5
        stack.axis = axis
        stack.alignment = .fill
        stack.distribution = distribution
        return stack
    }
}

