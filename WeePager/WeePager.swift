//
//  MyPager.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import UIKit

public class WeePager: UIView {
    
    internal var menu: MenuView!
    internal var body: BodyView!
    private var separator: UIView = UIView()
    internal var page: Int = 0
    internal var bodyOldIndex: Int = 0
    public var delegate: MyPagerDelegate?
    public var isLoaded: Bool = false
    public var bodyInteractable: Bool = true {
        didSet {
            body?.isUserInteractionEnabled = bodyInteractable
        }
    }
    public var menuInteractable: Bool = true {
        didSet {
            menu?.isUserInteractionEnabled = menuInteractable
        }
    }
    private var menuLeftConst: NSLayoutConstraint!
    private var bodyTopConst: NSLayoutConstraint!
    
    @IBInspectable public var loadAllPages : Bool = true
    @IBInspectable public var pagesOffLimit : Int = 5
    @IBInspectable public var initialPage : Int = 0
    @IBInspectable public var animateMenuSelectionScroll : Bool = true
    
    @IBInspectable public var menuHeight : CGFloat = 50
    public var menuPosition : menuPosition = .top
    @IBInspectable public var menuBackgroundColor : UIColor = .white
    @IBInspectable public var menuInset : CGFloat = 32
    @IBInspectable public var menuShadowEnabled : Bool = false
    @IBInspectable public var menuShadowOpacity : Float = 0.4
    @IBInspectable public var menuShadowRadius : CGFloat = 1.5
    @IBInspectable public var menuShadowWidth : CGFloat = 0
    @IBInspectable public var menuShadowHeight : CGFloat = 2.5
    @IBInspectable public var menuFillItems : Bool = true
    
    @IBInspectable public var separatorHeight : CGFloat = 0
    @IBInspectable public var separatorColor : UIColor = .black
    @IBInspectable public var separatorInset : CGFloat = 0
    @IBInspectable public var separatorMarginTop : CGFloat = 0
    @IBInspectable public var separatorMarginBottom : CGFloat = 0
    
    @IBInspectable public var itemMaxLines : Int = 1
    @IBInspectable public var itemMinWidth : CGFloat = 50
    @IBInspectable public var itemMaxWidth : CGFloat = 150
    @IBInspectable public var itemInset : CGFloat = 16
    @IBInspectable public var itemAlignment : UIControlContentHorizontalAlignment = .center
    
    @IBInspectable public var itemBoldSelected : Bool = true
    @IBInspectable public var itemCanColor : Bool = true
    @IBInspectable public var itemColor : UIColor = .gray
    @IBInspectable public var itemSelectedColor : UIColor = .black
    @IBInspectable public var itemFont : UIFont = UIFont.systemFont(ofSize: 17)
    @IBInspectable public var itemBoldFont : UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    @IBInspectable public var indicatorView : UIView = UIView()
    @IBInspectable public var indicatorColor : UIColor = .black
    @IBInspectable public var indicatorWidthAnimated : Bool = true
    @IBInspectable public var indicatorWidth : CGFloat = 50
    @IBInspectable public var indicatorHeight : CGFloat = 3
    @IBInspectable public var indicatorCornerRadius : CGFloat = 2
    public var indicatorAlign : indicatorAlignment = .bottom
    @IBInspectable public var indicatorAlpha : CGFloat = 1.0
    @IBInspectable public var indicatorOffsetY : CGFloat = 0.0
    
    @IBInspectable public var bodyScrollable : Bool = true
    @IBInspectable public var bodyBounceable : Bool = true
    
    @IBInspectable public var menuScrollable : Bool = true {
        didSet {
            menu?.isScrollEnabled = menuScrollable
        }
    }
    
    @IBInspectable public var infiniteScroll : Bool = false
    
    public func set(viewControllers: [UIViewController], titles: [String]?, images: [UIImage]?) {
        
        guard viewControllers.count > 0 else {
            print("WeePager WARNING: - add at least one viewController to init the pager")
            return
        }
        
        var titleArray = [String]()
        if titles == nil || titles?.count != viewControllers.count {
            for elem in viewControllers {
                let title = (elem.title != nil) ? elem.title! : ""
                titleArray.append(title)
            }
        } else {
            titleArray = titles!
        }
        
        if menu != nil {
            menu.removeFromSuperview()
            body.removeFromSuperview()
            separator.removeFromSuperview()
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
        
        body.isUserInteractionEnabled = bodyInteractable
        menu.isUserInteractionEnabled = menuInteractable
        
        menu.isScrollEnabled = menuScrollable
        
        self.addSubview(body)
        self.addSubview(menu)
        self.addSubview(separator)
        
        setConstraints()
        isLoaded = true
        
        didSetPage(index: initialPage)
    }
    
    private func setConstraints() {
        menuLeftConst = NSLayoutConstraint(item: menu, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        self.addConstraint(menuLeftConst)
        let rightConst = NSLayoutConstraint(item: menu, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        rightConst.priority = UILayoutPriority(rawValue: 750)
        self.addConstraint(rightConst)
        self.addConstraint(NSLayoutConstraint(item: menu, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.menuHeight))
        self.addConstraint(NSLayoutConstraint(item: body, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: body, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .leading, relatedBy: .equal, toItem: menu, attribute: .leading, multiplier: 1.0, constant: self.separatorInset))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .trailing, relatedBy: .equal, toItem: menu, attribute: .trailing, multiplier: 1.0, constant: -self.separatorInset))
        self.addConstraint(NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.separatorHeight))
        
        if self.menuPosition == .top {
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .bottom, relatedBy: .equal, toItem: separator, attribute: .top, multiplier: 1.0, constant: -separatorMarginTop))
            bodyTopConst = NSLayoutConstraint(item: separator, attribute: .bottom, relatedBy: .equal, toItem: body, attribute: .top, multiplier: 1.0, constant: -separatorMarginBottom)
            self.addConstraint(bodyTopConst)
            let bodyBotConst = NSLayoutConstraint(item: body, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
            bodyBotConst.priority = UILayoutPriority(rawValue: 750)
            self.addConstraint(bodyBotConst)
        } else {
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: menu, attribute: .top, relatedBy: .equal, toItem: separator, attribute: .bottom, multiplier: 1.0, constant: separatorMarginBottom))
            self.addConstraint(NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: body, attribute: .bottom, multiplier: 1.0, constant: separatorMarginTop))
            self.addConstraint(NSLayoutConstraint(item: body, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        }
        
    }
    
    override public func layoutSubviews() {
        guard body != nil else {
            return
        }
        body.delegate = nil
        super.layoutSubviews()
        menu.frame = CGRect(x: 0, y: (self.menuPosition == .top) ? 0 : self.frame.height-self.menuHeight, width: self.frame.width, height: self.menuHeight)
        menu.updateLayout()
        body.frame = CGRect(x: 0, y: (self.menuPosition == .top) ? self.menuHeight : 0, width:self.frame.width, height: self.frame.height-self.menuHeight)
        body.updateLayout()
        body.delegate = body
    }
    
    internal func didSetPage(index: Int) {
        page = index
        delegate?.pagerDidMoveToPage?(index: page)
    }
    
    internal func isSettingPage(index: Int) {
        guard !infiniteScroll else {
            if bodyOldIndex != index {
                body.updateInfiniteViewControllersPosition(forward: (index > bodyOldIndex))
                page += (index > bodyOldIndex) ? 1 : -1
                bodyOldIndex = index
                if page == body.viewControllers.count {
                    page = 0
                } else if page < 0 {
                    page = body.viewControllers.count-1
                }
                
                delegate?.pagerIsMovingToPage?(index: page)
            }
            return
        }
        
        if page != index {
            page = index
            menu.setSelected(index: page)
            delegate?.pagerIsMovingToPage?(index: page)
        }
    }
    
    public func setPage(forIndex index: Int, animated: Bool) {
        guard !infiniteScroll else {
            page = index
            body.updateLayout()
            page = index
            return
        }
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
    
    public func setMenuElementTitle(forIndex index: Int, title: String) {
        menu.setMenuElement(title: title, index: index)
    }
    
    public func reloadData() {
        for vc in body.viewControllers {
            vc.viewWillAppear(true)
            vc.viewDidAppear(true)
        }
    }
    
    public func prepareToAnimate(show: Bool) {
        menuLeftConst.constant = (show) ? UIScreen.main.bounds.width : 0
        bodyTopConst.constant = (show) ? -self.frame.height : 0
    }
    
    public func animate(show: Bool, time: Double, options: UIViewAnimationOptions, completion: (()->())? = nil ) {
        menuLeftConst.constant = (show) ? 0 : UIScreen.main.bounds.width+16
        bodyTopConst.constant = (show) ? 0 : -self.frame.height
        
        UIView.animate(withDuration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: options, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
            if show {
                self.layoutSubviews()
            }
        })
    }
    
    public func set(menuShadowVisible visible: Bool) {
        self.menuShadowEnabled = visible
        self.menu.setShadow()
    }
    
    public func refreshMenuProperties() {
        menu.refreshMenuProperties()
    }
}

public enum indicatorAlignment : String {
    case top = "top"
    case middle = "middle"
    case bottom = "bottom"
}

public enum menuPosition : String {
    case top = "top"
    case bottom = "bottom"
}

@objc public protocol MyPagerDelegate {
    @objc optional func pagerWillBeginMoving(fromIndex index: Int)
    @objc optional func pagerDidMoveToPage(index: Int)
    @objc optional func pagerIsMovingToPage(index: Int)
    @objc optional func percentageScrolled(percentage: Double)
    @objc optional func pagerMenuSelected(index: Int)
}

