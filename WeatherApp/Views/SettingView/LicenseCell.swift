//
//  LicenseCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class LicenseCell: UITableViewCell {

    let mainLabel = FormatUI.Label(ofSize: .small, weight: .regular, color: .label).makeLabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }
    }

}
// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView1: PreviewProvider {
    static var previews: some View {
        LicenseController()
            .toPreview()
    }
}
#endif
