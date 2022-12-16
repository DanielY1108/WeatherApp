//
//  TextView+.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/08.
//

import UIKit

extension UITextView {
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        self.text = originalText
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: fullRange)
        
        self.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.systemBlue,
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,
        ] as [NSAttributedString.Key : Any]
        
        self.attributedText = attributedOriginalText
    }
}
