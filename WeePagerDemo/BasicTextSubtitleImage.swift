//
//  RootTableViewCell.swift
//  MyTableView
//
//  Created by Federico Gentile on 21/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

class BasicTextSubtitleImageCell: UITableViewCell {
    
    let cellTitleLabel = UILabel()
    let cellSubtitleLabel = UILabel()
    let cellImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Set Image
        cellImage.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(cellImage)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        self.contentView.addConstraint(NSLayoutConstraint(item: cellImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellImage, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellImage, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellImage, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -8))
        
        //Set Title Label
        cellTitleLabel.numberOfLines = 0
        cellTitleLabel.baselineAdjustment = .alignBaselines
        cellTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(cellTitleLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellTitleLabel, attribute: .leading, relatedBy: .equal, toItem: cellImage, attribute: .trailing, multiplier: 1.0, constant: 8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 8))
        
        //Set Subtitle Label
        cellSubtitleLabel.numberOfLines = 0
        cellSubtitleLabel.baselineAdjustment = .alignBaselines
        cellSubtitleLabel.textColor = UIColor.lightGray
        cellSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(cellSubtitleLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellSubtitleLabel, attribute: .leading, relatedBy: .equal, toItem: cellImage, attribute: .trailing, multiplier: 1.0, constant: 8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellSubtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -8))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellSubtitleLabel, attribute: .top, relatedBy: .equal, toItem: cellTitleLabel, attribute: .bottom, multiplier: 1.0, constant: 4))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: cellSubtitleLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(titleText text: String) {
        cellTitleLabel.text = text
    }
    
    func set(subtitleText text: String) {
        cellSubtitleLabel.text = text
    }
    
    func set(image: UIImage) {
        cellImage.image = image
    }
}
