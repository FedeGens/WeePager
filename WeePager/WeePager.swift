//
//  MyPager.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import UIKit

public class WeePager: UIView {
    
    private var menu: MenuView!
    private var body: BodyView!
    private var separator: UIView = UIView()
    private var page: Int = 0
    var delegate: MyPagerDelegate?
    
    @IBInspectable var loadAllPages : Bool = true
    @IBInspectable var pagesOffLimit : Int = 5
    @IBInspectable var initialPage : Int = 0
    @IBInspectable var animateMenuSelectionScroll : Bool = true
    
    @IBInspectable var menuHeight : CGFloat = 50
    @IBInspectable var menuPosition : menuPosition = .top
    @IBInspectable var menuBackgroundColor : UIColor = .white
    @IBInspectable var menuInset : CGFloat = 32
    
    @IBInspectable var separatorHeight : CGFloat = 0
    @IBInspectable var separatorColor : UIColor = .black
    @IBInspectable var separatorInset : CGFloat = 0
    @IBInspectable var separatorMarginTop : CGFloat = 0
    @IBInspectable var separatorMarginBottom : CGFloat = 0
    
    @IBInspectable var itemMaxLines : Int = 1
    @IBInspectable var itemMinWidth : CGFloat = 50
    @IBInspectable var itemMaxWidth : CGFloat = 150
    @IBInspectable var itemInset : CGFloat = 16
    
    @IBInspectable var itemBoldSelected : Bool = true
    @IBInspectable var itemCanColor : Bool = true
    @IBInspectable var itemColor : UIColor = .gray
    @IBInspectable var itemSelectedColor : UIColor = .black
    @IBInspectable var itemFontSize : CGFloat = 17
    
    @IBInspectable var indicatorView : UIView = UIView()
    @IBInspectable var indicatorColor : UIColor = .black
    @IBInspectable var indicatorWidthAnimated : Bool = true
    @IBInspectable var indicatorWidth : CGFloat = 50
    @IBInspectable var indicatorHeight : CGFloat = 3
    @IBInspectable var indicatorCornerRadius : CGFloat = 2
    @IBInspectable var indicatorAlign : indicatorAlignment = .bottom
    @IBInspectable var indicatorAlpha : CGFloat = 1.0
    
    public func set(viewControllers: [UIViewController], titles: [String]?, images: [UIImage]?) {
        var titleArray = [String]()
        if titles == nil || titles?.count != viewControllers.count {
            for elem in viewControllers {
                let title = (elem.title != nil) ? elem.title! : ""
                titleArray.append(title)
            }
        } else {
            titleArray = titles!
        }
        
        menu = MenuView(frame: CGRect(x: 0, y: (self.menuPosition == .top) ? 0 : self.frame.height-self.menuHeight, width:self.frame.width, height: self.menuHeight), titles: titleArray, images: images, pagerReference: self)
        body = BodyView(frame: CGRect(x: 0, y: (self.menuPosition == .top) ? self.menuHeight : 0, width:self.frame.width, height: self.frame.height-self.menuHeight), viewControllers: viewControllers, pagerReference: self)
        separator.backgroundColor = separatorColor
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        menu.bodyReference = body
        body.menuReference = menu
        menu.setSelected(index: page)
        
        self.addSubview(menu)
        self.addSubview(body)
        self.addSubview(separator)
        
        setConstraints()
    }
    
    private func setConstraints() {
        self.addConstraint(NSLayoutConstraint(item: menu, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: menu, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: menu, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.menuHeight))
        self.addConstraint(NSLayoutConstraint(item: body, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: body, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .leading, relatedBy: .equal, toItem: menu, attribute: .leading, multiplier: 1.0, constant: self.separatorInset))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .trailing, relatedBy: .equal, toItem: menu, attribute: .trailing, multiplier: 1.0, constant: -self.separatorInset))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.separatorHeight))
        
        if self.menuPosition == .top {
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .bottom, relatedBy: .equal, toItem: separator, attribute: .top, multiplier: 1.0, constant: -separatorMarginTop))
            self.addConstraint(NSLayoutConstraint(item: separator, attribute: .bottom, relatedBy: .equal, toItem: body, attribute: .top, multiplier: 1.0, constant: -separatorMarginBottom))
            self.addConstraint(NSLayoutConstraint(item: body, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .top, relatedBy: .equal, toItem: separator, attribute: .bottom, multiplier: 1.0, constant: separatorMarginBottom))
            self.addConstraint(NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: body, attribute: .bottom, multiplier: 1.0, constant: separatorMarginTop))
            self.addConstraint(NSLayoutConstraint(item: body, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        }
        
    }
    
    override public func layoutSubviews() {
        body.delegate = nil
        super.layoutSubviews()
        body.updateLayout()
        body.delegate = body
    }
    
    internal func didSetPage(index: Int) {
        page = index
        delegate?.pagerDidMoveToPage(index: page)
    }
    
    internal func isSettingPage(index: Int) {
        if page != index {
            page = index
            menu.setSelected(index: page)
            delegate?.pagerIsMovingToPage(index: page)
        }
    }
    
    public func setPage(forIndex index: Int, animated: Bool) {
        body.moveToPage(index: index, animated: animated)
    }
    
    public func getPage() -> Int {
        return page
    }
    
    
    public func setIndicatorImage(withName name: String) {
        let myImage = UIImage(named: name)!
        setIndicatorImage(withImage: myImage)
    }
    
    public func setIndicatorImage(withImage image: UIImage) {
        let myImageView = UIImageView(image: image)
        indicatorView = myImageView
        indicatorColor = .clear
    }
}

enum indicatorAlignment : String {
    case top = "top"
    case middle = "middle"
    case bottom = "bottom"
}

enum menuPosition : String {
    case top = "top"
    case bottom = "bottom"
}

internal protocol MyPagerDelegate {
    func pagerDidMoveToPage(index: Int)
    func pagerIsMovingToPage(index: Int)
}
