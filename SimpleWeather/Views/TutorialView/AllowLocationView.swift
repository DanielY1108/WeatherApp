//
//  AllowLocationView.swift
//  SimpleWeather
//
//  Created by JINSEOK on 2022/12/22.
//

import UIKit

protocol LocationViewButtonDelegate {
    func tappedContinue()
}

class AllowLocationView: UIView {
    var delegate: LocationViewButtonDelegate?
    
    private let locationImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "location_btn")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 30, weight: .bold)
        lable.textAlignment = .center
        lable.numberOfLines = 0
        return lable
    }()
    private let mainTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 20)
        view.isEditable = false
        return view
    }()
    private let continueButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.backgroundColor = .systemGreen
        return button
    }()
    private let footerLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.numberOfLines = 0
        return lable
    }()
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, mainTextView, continueButton, footerLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupText()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(locationImage)
        locationImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        self.addSubview(labelStackView)
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(locationImage.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        self.continueButton.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
    }
    @objc private func pressedButton(_ sender: UIButton) {
        delegate?.tappedContinue()
    }
    private func setupText() {
        titleLabel.text = "Location services"
        mainTextView.hyperLink(originalText: readTextFile(), hyperLink: "Privacy Policy", urlString: "https://daniel-yang.notion.site/Privacy-Policy-Eng-d80cd6f939cd47c28a4ed095a5a1911b", fontSize: 18)
        footerLabel.text = "You can change this option later in the Setting app."
    }
    private func readTextFile() -> String {
        var result = ""
        guard let pahts = Bundle.main.path(forResource: "tutorialText.txt", ofType: nil) else { return "" }
        do {
            result = try String(contentsOfFile: pahts, encoding: .utf8)
            return result
        } catch {
            return "Error: file read failed - \(error.localizedDescription)"
        }
    }
    
}

