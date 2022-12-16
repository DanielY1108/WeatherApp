//
//  ProfileController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class ProfileController: UIViewController {
    
    let profileView = ProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
