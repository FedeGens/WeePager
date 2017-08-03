//
//  MenuView.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import UIKit

@IBDesignable
class MenuView: UIScrollView {
    
    private var buttons : [UIButton] = [UIButton]()
    private var selectedElem : Int = 0
    private var indicator: UIView!
    var bodyReference: BodyView!
    var pagerReference: WeePager!
    
    init(frame: CGRect, titles: [String], images: [UIImage]?, pagerReference: WeePager) {
        super.init(frame: frame)
        
        self.pagerReference = pagerReference
        self.backgroundColor = pagerReference.menuBackgroundColor
        setMenu(titles: titles, images: images)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setMenu(titles:[String], images: [UIImage]?) {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        var myOffset: CGFloat = pagerReference.menuInset
        
        // Create and add buttons to menu
        for i in 0...titles.count-1 {
            let menuButton = UIButton()
            
            if images != nil {
                menuButton.imageView?.contentMode = .scaleAspectFit
                menuButton.imageView?.tintColor = pagerReference.itemColor
                menuButton.setImage(images![i].withRenderingMode(.alwaysTemplate), for: .normal)
            } else {
                menuButton.setTitle(titles[i], for: .normal)
                menuButton.titleLabel?.font = pagerReference.itemFont
                menuButton.titleLabel?.lineBreakMode = .byTruncatingTail
                menuButton.titleLabel?.textAlignment = .center
                menuButton.titleLabel?.numberOfLines = pagerReference.itemMaxLines
                menuButton.setTitleColor(pagerReference.itemColor, for: .normal)
            }
            
            var myButtonWidth = menuButton.intrinsicContentSize.width + pagerReference.itemInset
            if myButtonWidth < pagerReference.itemMinWidth {
                myButtonWidth = pagerReference.itemMinWidth
            }
            if myButtonWidth > pagerReference.itemMaxWidth {
                myButtonWidth = pagerReference.itemMaxWidth
            }
            menuButton.frame = CGRect(x: myOffset, y: 0, width: myButtonWidth, height: pagerReference.menuHeight)
            menuButton.tag = i
            menuButton.addTarget(self, action: #selector(MenuView.buttonPressed(sender:)), for: .touchUpInside)
            
            buttons.append(menuButton)
            self.addSubview(menuButton)
            myOffset += menuButton.frame.width
        }
        myOffset += pagerReference.menuInset
        
        //Fill offset
        if myOffset < self.frame.width {
            let diff = self.frame.width - myOffset
            let singleDiff = diff/CGFloat(buttons.count)
            
            myOffset = pagerReference.menuInset
            for elem in buttons {
                elem.frame = CGRect(x: myOffset, y: 0, width: elem.frame.width+singleDiff, height: pagerReference.menuHeight)
                myOffset += elem.frame.width
            }
            myOffset += pagerReference.menuInset
        }
        
        contentSize = CGSize(width: myOffset, height: pagerReference.menuHeight)
        
        let indicatorY = (pagerReference.indicatorAlign == .top) ? 0 : (pagerReference.indicatorAlign == .bottom) ? self.frame.height-pagerReference.indicatorHeight : (self.frame.height-pagerReference.indicatorHeight) / 2
        let indicatorWidth = (pagerReference.indicatorWidthAnimated) ? buttons[0].frame.width : pagerReference.indicatorWidth
        indicator = pagerReference.indicatorView
        indicator.frame = CGRect(x: pagerReference.menuInset + buttons[0].frame.width/2 - indicatorWidth/2, y: indicatorY, width: indicatorWidth, height: pagerReference.indicatorHeight)
        indicator.layer.cornerRadius = pagerReference.indicatorCornerRadius
        indicator.backgroundColor = pagerReference.indicatorColor
        indicator.alpha = pagerReference.indicatorAlpha
        self.addSubview(indicator)
        
        //Shadow
        if pagerReference.menuShadowEnabled {
            setShadow()
        }
    }
    
    internal func updateLayout() {
        var myOffset: CGFloat = pagerReference.menuInset
        for elem in buttons {
            var myButtonWidth = elem.intrinsicContentSize.width + pagerReference.itemInset
            if myButtonWidth < pagerReference.itemMinWidth {
                myButtonWidth = pagerReference.itemMinWidth
            }
            if myButtonWidth > pagerReference.itemMaxWidth {
                myButtonWidth = pagerReference.itemMaxWidth
            }
            elem.frame = CGRect(x: myOffset, y: 0, width: myButtonWidth, height: pagerReference.menuHeight)
            myOffset += elem.frame.width
        }
        myOffset += pagerReference.menuInset
        
        if myOffset < self.frame.width {
            let diff = self.frame.width - myOffset
            let singleDiff = diff/CGFloat(buttons.count)
            
            myOffset = pagerReference.menuInset
            for elem in buttons {
                elem.frame = CGRect(x: myOffset, y: 0, width: elem.frame.width+singleDiff, height: pagerReference.menuHeight)
                myOffset += elem.frame.width
            }
            myOffset += pagerReference.menuInset
        }
        contentSize = CGSize(width: myOffset, height: pagerReference.menuHeight)
        indicator.frame.origin.x = getButtonPosition(index: pagerReference.getPage()) - indicator.frame.width/2
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        bodyReference.moveToPage(index: sender.tag, animated: pagerReference.animateMenuSelectionScroll)
        if !pagerReference.animateMenuSelectionScroll {
            moveIndicator(offsetX: Double(self.frame.width)*Double(sender.tag))
        }
    }
    
    func moveIndicator(offsetX: Double) {
        let (position,width) = getIndicatorAbsolutePosition(offsetX: offsetX)
        
        indicator.frame.origin.x = position
        indicator.frame.size = CGSize(width: width, height: indicator.frame.height)
        checkMenuScroll()
    }
    
    private func getIndicatorAbsolutePosition(offsetX: Double) -> (CGFloat, CGFloat) {
        var position : CGFloat = 0
        var width : CGFloat = 0
        guard self.frame.width != 0 else {
            return (indicator.frame.origin.x, indicator.frame.size.width)
        }
        let startingIndex = Int(offsetX/Double(self.frame.width))
        let internalOffsetPercentage = offsetX.truncatingRemainder(dividingBy: Double(self.frame.width)) / Double(self.frame.width)
        let internalIndicatorOffsset = Double(getButtonDistance(index: startingIndex)) * internalOffsetPercentage
        
        let widthOffset = (startingIndex+1 < buttons.count) ? buttons[startingIndex+1].frame.width - buttons[startingIndex].frame.width : 0
        let internalWidthOffset = widthOffset * CGFloat(internalOffsetPercentage)
        
        position = getButtonPosition(index: startingIndex) + CGFloat(internalIndicatorOffsset) - indicator.frame.width/2
        width = (pagerReference.indicatorWidthAnimated) ? buttons[startingIndex].frame.width + internalWidthOffset : indicator.frame.size.width
        
        return (position, width)
    }
    
    private func getButtonPosition(index: Int) -> CGFloat {
        let position = buttons[index].frame.origin.x + buttons[index].frame.width/2
        return position
    }
    
    private func getButtonDistance(index: Int) -> CGFloat {
        let distance = (index+1 < buttons.count) ? getButtonPosition(index: index+1) - getButtonPosition(index: index) : buttons[index].frame.width
        return distance
    }
    
    private func checkMenuScroll() {
        var newX = indicator.frame.origin.x - (frame.width - indicator.frame.width)/2
        newX = (newX < 0) ? 0 : (newX > self.contentSize.width - self.frame.width) ? self.contentSize.width - self.frame.width : newX
        self.setContentOffset(CGPoint(x: newX, y: 0), animated: false)
    }
    
    internal func setSelected(index: Int) {
        if pagerReference.itemBoldSelected {
            buttons[selectedElem].titleLabel?.font = pagerReference.itemFont
            buttons[index].titleLabel?.font = pagerReference.itemBoldFont
        }
        
        if pagerReference.itemCanColor {
            buttons[selectedElem].setTitleColor(pagerReference.itemColor, for: .normal)
            buttons[selectedElem].imageView?.tintColor = pagerReference.itemColor
            buttons[index].setTitleColor(pagerReference.itemSelectedColor, for: .normal)
            buttons[index].imageView?.tintColor = pagerReference.itemSelectedColor
        }
        selectedElem = index
        bodyReference.checkCreatedPages(index: index)
    }
    
    internal func setMenuElement(title: String, index: Int) {
        buttons[index].setTitle(title, for: .normal)
    }
    
    //MARK: Shadow
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = false
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 1.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
}
