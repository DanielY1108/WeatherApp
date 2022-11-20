//
//  Utilities.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/15.
//

import UIKit

enum ImageFormat {
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
    
    func configImange(format: ImageFormat, name: String) -> UIImageView {
        let view = UIImageView()
        switch format {
        case .user:
            view.image = UIImage(named: name)
        case .system:
            view.image = UIImage(systemName: name)
        }
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func configStackView(_ stacks: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: stacks)
        stack.spacing = 7
        stack.axis = axis
        stack.alignment = alignment
        stack.distribution = distribution
        return stack
    }
}

