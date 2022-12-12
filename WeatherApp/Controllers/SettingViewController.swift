//
//  SettingViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let settingList: [Setting] = [
        Setting(title: .location, section: .user),
        Setting(title: .temperature, section: .user),
        Setting(title: .about, section: .info),
        Setting(title: .openSource, section: .info),
        Setting(title: .version, section: .info)
    ]
    private lazy var userList = settingList.filter { SettingSection.user == $0.section }
    private lazy var infoList = settingList.filter { SettingSection.info == $0.section }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavigationBar()
    }
    override func viewDidLayoutSubviews() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: Constants.ID.settingID)
    }
}
// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(sectionIndex: section) else { return 0 }
        
        switch section {
        case .user:
            return userList.count
        case .info:
            return infoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.settingID, for: indexPath) as! SettingCell
        guard let section = SettingSection(sectionIndex: indexPath.section) else { return cell }
        cell.selectionStyle = .none
        
        let switchView = UISwitch(frame: .zero)
        
        switch section {
        case .user:
            cell.mainLabel.text = userList[indexPath.row].title.rawValue
            switch indexPath.row {
            case 0:
                switchView.addTarget(self, action: #selector(self.locationSwitchChanged(_:)), for: .valueChanged)
                switch LocationManager.shared.manager.authorizationStatus {
                case .denied, .restricted, .notDetermined:
                    switchView.isOn = false
                case .authorizedWhenInUse, .authorizedAlways:
                    switchView.isOn = true
                default: break
                }
            default:
                switchView.addTarget(self, action: #selector(self.unitSwitchChanged(_:)), for: .valueChanged)
                switchView.setOn(UserDefaults.standard.bool(forKey: Constants.UserDefault.unitSwitch), animated: true)
            }
            cell.accessoryView = switchView
            
            return cell
        case .info:
            cell.mainLabel.text = infoList[indexPath.row].title.rawValue
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingSection(sectionIndex: section) else { return "" }
        
        switch section {
        case .user:
            return SettingSection.titleOfUser
        case .info:
            return SettingSection.titleOfInfo
        }
    }
}
// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingSection(sectionIndex: indexPath.section) else { return }
        
        switch section {
        case .user: break
        case .info:
            switch infoList[indexPath.row].title {
            case .about:
                navigationController?.show(ProfileController(), sender: nil)
                print("about")
            case .openSource:
                navigationController?.show(LicenseController(), sender: nil)
                print("opensource")
            case .version:
                print("version")
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
// MARK: - Setup Switch
extension SettingViewController: SwitchDelegate {
    @objc func locationSwitchChanged(_ sender: UISwitch) {
        switch LocationManager.shared.manager.authorizationStatus {
        case .denied, .restricted, .notDetermined:
            sender.isOn = false
            setAuthAlertAction(with: sender)
            print("Switch Off")
        case .authorizedWhenInUse, .authorizedAlways:
            sender.isOn = true
            setAuthAlertAction(with: sender)
            print("Switch On")
        default: break
        }
    }
    
    @objc func unitSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.UserDefault.unitSwitch)
        if sender.isOn {
            print("Switch On")
        } else {
            print("Switch Off")
        }
    }
    
}
// MARK: - Alert(Setting Location)
extension SettingViewController {
    func setAuthAlertAction(with switchs: UISwitch) {
        let authAlertController = UIAlertController(title: "Request location permissions", message: "Would you like to go to location permission settings?", preferredStyle: .alert)
        
        let setting = UIAlertAction(title: "setting", style: .default) { action in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                print("Setting button tapped")
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { action in
            print("Cancel button tapped")
        }
        authAlertController.addAction(setting)
        authAlertController.addAction(cancel)
        self.present(authAlertController, animated: true, completion: nil)
    }
}
// MARK: - Setup NavigationBar
extension SettingViewController {
    private func configNavigationBar() {
        SetupNavigation(appearance: UINavigationBarAppearance()).setup(with: self, title: .setting)
    }
}

