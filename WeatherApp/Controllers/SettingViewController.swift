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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavigationBar()
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: Constants.ID.settingID)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        
        switch section {
        case .user:
            cell.mainLabel.text = userList[indexPath.row].title.rawValue
        case .info:
            cell.mainLabel.text = infoList[indexPath.row].title.rawValue
        }
        cell.selectionStyle = .none
        return cell
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
        case .user:
            switch userList[indexPath.row].title {
            case .location:
                print("location")
            case .temperature:
                print("temp")
            default:
                break
            }
        case .info:
            switch infoList[indexPath.row].title {
            case .about:
                print("about")
            case .openSource:
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

// MARK: - Setup NavigationBar

extension SettingViewController {
    private func configNavigationBar() {
        SetupNavigation(appearance: UINavigationBarAppearance()).setup(with: self, title: .setting)
        self.navigationItem.title = "Setting"
    }
}

