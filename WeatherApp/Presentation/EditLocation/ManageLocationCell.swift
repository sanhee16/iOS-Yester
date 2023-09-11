//
//  ManageLocationCell.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/08.
//

import Foundation
import UIKit
import Combine
import PinLayout
import FlexLayout

class ManageLocationCell: UICollectionViewCell {
    typealias VM = ManageLocationViewModel
    
    static let identifier = "ManageLocationCell"
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate lazy var name: UILabel = UILabel()
    fileprivate lazy var locationImage: UIImageView = UIImageView()
    fileprivate lazy var delete: UIButton = UIButton()
    
    var isLoad: Bool = false
    var vm: VM? = nil
    var location: Location? = nil
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Remove any state in this cell that may be left over from its previous use.
        self.vm = nil
        self.location = nil
    }
    
    func configure(_ vm: VM, location: Location) {
        self.vm = vm
        self.location = location
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.rootFlexContainer = UIView()
        self.setLayout()
        
        self.layout()
    }
    
    private func layout() {
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.layoutSubviews()
        //        rootFlexContainer.pin.top().horizontally().margin(pin.safeArea)
        rootFlexContainer.pin.top().left().width(size.width)
        self.layout()
        return rootFlexContainer.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        self.layout()
    }
    
    private func setLayout() {
        self.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.start)
            .define { (flex) in
                if let location = self.location {
                    locationItem(flex, location: location)
                }
                divider(flex)
            }
    }
    
    //MARK: View
    private func divider(_ flex: Flex) {
        flex.addItem()
            .marginHorizontal(14)
            .define { flex in
                let view = UIView()
                view.backgroundColor = .black.withAlphaComponent(0.1)
                view.pin.width(100%).height(1)
                flex.addItem(view)
            }
    }
    
    private func locationItem(_ flex: Flex, location: Location) {
        flex.addItem()
            .direction(.row)
            .justifyContent(location.isCurrent ? .start : .spaceBetween)
            .cornerRadius(6)
            .marginHorizontal(14)
            .define { flex in
                name.numberOfLines = 0
                name.text = location.name
                name.font = .en16r
                name.flex.paddingVertical(10)
                name.flex.shrink(1)
                flex.addItem(name)
                
                if location.isCurrent {
                    locationImage.flex.shrink(0)
                    locationImage.contentMode = .scaleAspectFit
                    locationImage.image = UIImage(systemName: "location.fill")?.resized(toWidth: 13)
                    flex.addItem(locationImage).marginLeft(4)
                } else {
                    let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
                    let image: UIImage? = UIImage(systemName: "x.circle.fill", withConfiguration: config)?.withTintColor(.primeColor2, renderingMode: .alwaysOriginal)
                    let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(self.onClickDelete), location: location)
                    delete.setImage(image, for: .normal)
                    delete.flex.padding(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0))
                    delete.addGestureRecognizer(tapGesture)
                    flex.addItem(delete)
                }
            }
    }
    
    @objc
    private func onClickDelete(sender: CustomTapGestureRecognizer) {
        vm?.onClickDelete(sender.location)
    }
    
    class CustomTapGestureRecognizer: UITapGestureRecognizer {
        let location: Location
        init(target: Any?, action: Selector?, location: Location) {
            self.location = location
            super.init(target: target, action: action)
        }
    }
}
