//
//  SelectLocationCell.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/02.
//

import Foundation
import UIKit
import SnapKit

class SelectLocationCell : UITableViewCell {
    typealias VM = SelectLocationViewModel
    static let identifier = "SelectLocationCell"
    
    var value: GeocodingItem?
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    
    let country: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill

        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1.2
        stackView.layer.borderColor = UIColor.primeColor1.withAlphaComponent(0.4).cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)

        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.value = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm: VM) {
        print("bind")
        vm.selectedItem.observe(on: self) { [weak self] item in
            guard let self = self else { return }
            if let item = item, let value = value, item == value {
                self.isSelected = true
                self.stackView.backgroundColor = UIColor.primeColor1.withAlphaComponent(0.4)
            } else {
                self.isSelected = false
                self.stackView.backgroundColor = .clear
            }
        }
    }
    
    private func addContentView() {
        [stackView].forEach {
            self.contentView.addSubview($0)
        }
        [name, country].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    private func autoLayout() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
        
        country.snp.makeConstraints { make in
            make.top.equalTo(self.name.snp.bottom)
        }
    }
}
