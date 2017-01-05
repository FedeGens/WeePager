//
//  BasicTableView.swift
//  MyTableView
//
//  Created by Federico Gentile on 25/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

class BasicTableView: RootTableView {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
    }
    
    func registerCells() {
        self.register(BasicTextCell.classForCoder(), forCellReuseIdentifier: BasicCellType.text.rawValue)
        self.register(BasicTextImageCell.classForCoder(), forCellReuseIdentifier: BasicCellType.textImage.rawValue)
        self.register(BasicTextSubtitleImageCell.classForCoder(), forCellReuseIdentifier: BasicCellType.textSubtitleImage.rawValue)
    }
    
    
    //MARK: create and add basic Header
    func addBasicHeader(withType type: BasicHeaderType, inSection section: Int, withTitle title: String, backgroundColor color: UIColor?, withHeight height: CGFloat?) {
        var view = UIView()
        switch type {
        case .text:
            view = BasicTextHeader.create(withText: title, backgroundColor: color)
        }
        setSectionHeader(view: view, atIndex: section, forHeight: height)
    }
    
    
    //MARK: create and add basic Cell
    func addBasicCell(withType type: BasicCellType, inSection section: Int, atIndex index: Int?, withTitle title: String?, withSubtitle subtitle: String?, withImage image: UIImage?) {
        var cell = UITableViewCell()
        switch type {
        case .text:
            cell = self.createBasicTextCell(withString: title)
        case .textImage:
            cell = self.createBasicTextImageCell(withString: title, image: image)
        case .textSubtitleImage:
            cell = self.createBasicTextSubtitleImageCell(withTitle: title, withSubtitle: subtitle, image: image)
        }
        
        self.add(cell: cell, inSection: section, atIndex: index)
    }
    
    
    //MARK: Create BasicText Cell
    func createBasicTextCell(withString text: String?) -> BasicTextCell {
        let cell = self.dequeueReusableCell(withIdentifier: BasicCellType.text.rawValue) as! BasicTextCell
        if let myText = text {
            cell.set(text: myText)
        }
        return cell
    }
    
    func createBasicTextCell() -> BasicTextCell {
        return self.dequeueReusableCell(withIdentifier: BasicCellType.text.rawValue) as! BasicTextCell
    }
    
    
    //MARK: Create BasicTextImage Cell
    func createBasicTextImageCell(withString text: String?, image: UIImage?) -> BasicTextImageCell {
        let cell = self.dequeueReusableCell(withIdentifier: BasicCellType.textImage.rawValue) as! BasicTextImageCell
        if let myText = text {
            cell.set(text: myText)
        }
        if let myImage = image {
            cell.set(image: myImage)
        }
        return cell
    }
    
    func createBasicTextImageCell() -> BasicTextImageCell {
        return self.dequeueReusableCell(withIdentifier: BasicCellType.textImage.rawValue) as! BasicTextImageCell
    }
    
    
    //MARK: Create BasicTextSubtitleImage Cell
    func createBasicTextSubtitleImageCell(withTitle title: String?, withSubtitle subtitle: String?, image: UIImage?) -> BasicTextSubtitleImageCell {
        let cell = self.dequeueReusableCell(withIdentifier: BasicCellType.textSubtitleImage.rawValue) as! BasicTextSubtitleImageCell
        if let myText = title {
            cell.set(titleText: myText)
        }
        if let myText = subtitle {
            cell.set(subtitleText: myText)
        }
        if let myImage = image {
            cell.set(image: myImage)
        }
        return cell
    }
    
    func createBasicTextSubtitleImageCell() -> BasicTextSubtitleImageCell {
        return self.dequeueReusableCell(withIdentifier: BasicCellType.textSubtitleImage.rawValue) as! BasicTextSubtitleImageCell
    }

}


enum BasicCellType: String {
    case text = "BASIC_CELL_TEXT"
    case textImage = "BASIC_CELL_TEXT_IMAGE"
    case textSubtitleImage = "BASIC_CELL_TEXT_SUBTITLE_IMAGE"
}

enum BasicHeaderType {
    case text
}
