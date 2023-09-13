//
//  SettingTitle.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/13.
//

import Foundation
import PinLayout
import FlexLayout
import UIKit

class SettingTitle: UIView {
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    var title: String = ""
    var descriptionText: String? = nil
    
    init(title: String, descriptionText: String? = nil) {
        self.title = title
        self.descriptionText = descriptionText
        super.init(frame: .zero)
        
        self.setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        self.layout()
    }
    
    private func setLayout() {
        self.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .width(100%)
            .direction(.column)
            .define { (flex) in
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .margin(8, 14)
                    .define { flex in
                        let titleLabel: UILabel = UILabel()
                        
                        titleLabel.font = .en16b
                        titleLabel.text = title
                        titleLabel.textColor = .black.withAlphaComponent(0.8)
                        
                        flex.addItem(titleLabel)
                        if let descriptionText = descriptionText {
                            let descriptionLabel: UILabel = UILabel()
                            
                            descriptionLabel.font = .en14r
                            descriptionLabel.text = descriptionText
                            descriptionLabel.textColor = .gray
                            
                            flex.addItem(descriptionLabel)
                        }
                    }
            }
    }
}
