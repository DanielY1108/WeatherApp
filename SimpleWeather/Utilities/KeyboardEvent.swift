//
//  KeyboardEvent.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/21.
//

import UIKit

protocol KeyboardEvent where Self: UIViewController {
    var transformView: UIView { get }
    func setupKeyboardEvent()
}

extension KeyboardEvent where Self: UIViewController {
    func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] notification in
            self?.keyboardWillAppear(notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] notification in
            self?.keyboardWillDisappear(notification)
        }
    }
    
    private func keyboardWillAppear(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        transformView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    private func keyboardWillDisappear(_ notification: Notification) {
        transformView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
