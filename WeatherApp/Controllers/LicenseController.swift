//
//  LicenseController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class LicenseController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let license: [Licenses] = [
        Licenses(name: .weatherKit),
        Licenses(name: .openWeather),
        Licenses(name: .realm),
        Licenses(name: .snapkit)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        configNavigationBar()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureUI() {
        self.view.addSubview(tableView)
        tableView.register(LicenseCell.self, forCellReuseIdentifier: Constants.ID.licenseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDataSource

extension LicenseController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.licenseID, for: indexPath) as! LicenseCell
        cell.mainLabel.text = license[indexPath.row].name.rawValue
        cell.accessoryType = .detailDisclosureButton
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
// MARK: - UITableViewDelegate

extension LicenseController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch license[indexPath.row].name {
        case .weatherKit:
            navigationController?.show(DetailLicenseController(), sender: nil)
        case .openWeather:
            navigationController?.show(DetailLicenseController(), sender: nil)
        case .realm:
            navigationController?.show(DetailLicenseController(), sender: nil)
        case .snapkit:
            navigationController?.show(DetailLicenseController(), sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
// MARK: - Setup NavigationBar
extension LicenseController {
    private func configNavigationBar() {
        SetupNavigation(appearance: UINavigationBarAppearance()).setup(with: self, title: .license)
    }
}

// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView: PreviewProvider {
    static var previews: some View {
        LicenseController()
            .toPreview()
    }
}
#endif
