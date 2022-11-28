//
//  Utilities.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/15.
//

import UIKit

enum ImageFormat {
    case userImage
    case systemImage
}

enum FontFormat: CGFloat {
    case title = 60.0
    case secondTitle = 40.0
    case medium = 20.0
    case main = 18.0
    case small = 16.0
    case Annotation = 13.0
}

// HeaderView Setting
struct FormatUI {
    struct Label {
        let ofSize: FontFormat
        let weight: UIFont.Weight
        var color: UIColor?

        var makeLabel: UILabel {
            let label = UILabel()
            label.font = .systemFont(ofSize: ofSize.rawValue, weight: weight)
            label.textColor = color ?? .black
            return label
        }
    }
    
    struct Image {
        let format: ImageFormat
        let name: String
        
        var makeImange: UIImageView {
            let view = UIImageView()
            switch format {
            case .userImage:
                view.image = UIImage(named: name)
            case .systemImage:
                view.image = UIImage(systemName: name)
            }
            view.tintColor = .systemBlue
            view.contentMode = .scaleAspectFit
            return view
        }
    }

    struct StackView {
        let subviews: [UIView]
        let axis: NSLayoutConstraint.Axis
        var distribution: UIStackView.Distribution?
        var alignment: UIStackView.Alignment?
        var spacing: CGFloat?
        
        var makeStackView: UIStackView {
            let stack = UIStackView(arrangedSubviews: subviews)
            stack.axis = axis
            stack.spacing = spacing ?? 7
            stack.alignment = alignment ?? .fill
            stack.distribution = distribution ?? .fill
            return stack
        }
    }
}

