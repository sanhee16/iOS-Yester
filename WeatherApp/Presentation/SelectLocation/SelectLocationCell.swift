//
//  SelectLocationCell.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/02.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class SelectLocationCell : UITableViewCell {
    typealias VM = SelectLocationViewModel
    static let identifier = "SelectLocationCell"
    
    var value: Geocoding?
    var vm: VM?
    private var isExist: Bool = false
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate lazy var view: UIView = UIView()
    fileprivate lazy var name: UILabel = UILabel()
    fileprivate lazy var country: UILabel = UILabel()
    fileprivate lazy var location: UILabel = UILabel()
    private var baseBackgroundColor: UIColor = .clear
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.value = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vm = nil
        self.value = nil
        
        self.name.text?.removeAll()
        self.country.text?.removeAll()
        self.location.text?.removeAll()
        
        self.layout()
    }
    
    func configure(_ vm: VM, value: Geocoding) {
        self.vm = vm
        self.value = value
        self.name.text = self.value?.localName
        self.country.text = self.value?.country
        self.location.text = "lat: \(self.value?.lat) // lon: \(self.value?.lon)"
        self.isExist = vm.existItems.contains(where: { loc in
            loc.lat == value.lat && loc.lon == value.lon
        })
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.rootFlexContainer = UIView()
        self.baseBackgroundColor = self.isExist ? UIColor.gray.withAlphaComponent(0.4) : .clear
        self.view.flex.border(1.2, self.isExist ? UIColor.gray.withAlphaComponent(0.8) : UIColor.primeColor1.withAlphaComponent(0.8))
        self.view.backgroundColor = self.baseBackgroundColor
        self.setLayout()
        
        self.layout()
        
        self.bind()
    }
    
    func bind() {
        vm?.status.observe(on: self) { [weak self] status in
            guard let self = self, let value = value else { return }
            switch status {
            case let .select(_, item):
                if item == value {
                    self.isSelected = true
                    self.view.backgroundColor = UIColor.primeColor1.withAlphaComponent(0.4)
                } else {
                    self.isSelected = false
                    self.view.backgroundColor = self.baseBackgroundColor
                }
                break
            default:
                self.isSelected = false
                self.view.backgroundColor = self.baseBackgroundColor
                break
            }
        }
    }
    
    private func layout() {
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.layoutSubviews()
        rootFlexContainer.pin.top().left().width(size.width)
        self.layout()
        return rootFlexContainer.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        view.pin.all()
        self.layout()
    }
    
    private func setLayout() {
        self.addSubview(rootFlexContainer)
        name.flex.markDirty()
        country.flex.markDirty()
        location.flex.markDirty()
        
        rootFlexContainer.flex
            .width(100%)
            .direction(.column)
            .padding(0, 12, 8)
            .define { (flex) in
                flex.addItem(view)
                    .width(100%)
                    .padding(6, 8)
                    .markDirty()
                    .direction(.column)
                    .justifyContent(.center)
                    .alignItems(.start)
                    .cornerRadius(6)
                    .define { flex in
                        name.numberOfLines = 0
                        country.numberOfLines = 0
                        location.numberOfLines = 0
                        
                        name.font = .en16b
                        country.font = .en14r
                        location.font = .en12r
                        location.textColor = .gray
                        
                        flex.addItem(name)
                        flex.addItem(country)
                        flex.addItem(location)
                    }
            }
    }
    
}
