//
//  UILabel+Highlight.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/21.
//

import UIKit

extension UILabel {
   func setHighlighted(for text: String, with search: String) {
       let attributedText = NSMutableAttributedString(string: text)
       let range = NSString(string: text).range(of: search, options: .caseInsensitive)
       let highlightFont = UIFont.systemFont(ofSize: 18)
       let highlightColor = UIColor.systemRed
       let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: highlightFont, NSAttributedString.Key.foregroundColor: highlightColor]
       
       attributedText.addAttributes(highlightedAttributes, range: range)
       self.attributedText = attributedText
   }
}
