//
//  BasicHeader.swift
//  MyTableView
//
//  Created by Federico Gentile on 25/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

class BasicTextHeader: UIView {
    
    let headerLabel = UILabel()
    let backGroundToolbar = UIToolbar()

    static func create(withText text: String, backgroundColor color: UIColor?) -> UIView {
        let basicTextHeader = BasicTextHeader()
        basicTextHeader.headerLabel.text = text
        basicTextHeader.backGroundToolbar.barTintColor = (color == nil) ? basicTextHeader.backGroundToolbar.barTintColor : color
        return basicTextHeader
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //set view clearcolor
        self.backgroundColor = UIColor.clear
        
        //set backgroundtoolbar constraints
        backGroundToolbar.alpha = 1.0
        backGroundToolbar.clipsToBounds = true
        backGroundToolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backGroundToolbar)
        
        self.addConstraint(NSLayoutConstraint(item: backGroundToolbar, attribute: .leading, relatedBy:
            .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: backGroundToolbar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: backGroundToolbar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: backGroundToolbar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        //set headerlabel constraints
        headerLabel.numberOfLines = 0
        headerLabel.baselineAdjustment = .alignBaselines
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(headerLabel)
        
        self.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8))
        
        self.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -8))
        
        self.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 8))
        
        self.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -8))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(color: UIColor, withAlpha alpha: CGFloat) {
        self.backgroundColor = color
        self.alpha = alpha
    }
}
