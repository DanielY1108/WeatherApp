//
//  LicenseController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class LicenseController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let licenses: [License] = [
        License(.weatherKit),
        License(.openWeather),
        License(.libraries)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return licenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.licenseID, for: indexPath) as! LicenseCell
        cell.mainLabel.text = licenses[indexPath.row].name
        print(licenses[indexPath.row].name)
        cell.accessoryType = .detailDisclosureButton
        cell.selectionStyle = .none
        return cell
    }
}
// MARK: - UITableViewDelegate

extension LicenseController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailLicenseController()
        detailViewController.licenseSeleted = licenses[indexPath.row]
        switch licenses[indexPath.row].type {
        case .weatherKit:
            navigationController?.show(detailViewController, sender: nil)
        case .openWeather:
            navigationController?.show(detailViewController, sender: nil)
        case .libraries:
            guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
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
