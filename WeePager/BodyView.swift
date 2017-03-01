//
//  BodyView.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import UIKit

@IBDesignable
class BodyView: UIScrollView, UIScrollViewDelegate {
    
    private var initialPosition : Double!
    private var viewControllers : [UIViewController] = [UIViewController]()
    var menuReference: MenuView!
    var pagerReference: WeePager!
    
    init(frame: CGRect, viewControllers: [UIViewController], pagerReference: WeePager) {
        super.init(frame: frame)
        
        self.pagerReference = pagerReference
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = false
        delegate = self
        
        self.viewControllers = viewControllers
        if pagerReference.loadAllPages {
            for elem in viewControllers {
                self.addSubview(elem.view)
            }
        }
        self.decelerationRate = UIScrollViewDecelerationRateNormal
    }
    
    internal func updateLayout() {
        for elem in viewControllers {
            let index = viewControllers.index(of: elem)!
            elem.view.frame.size = self.frame.size
            elem.view.frame.origin.x = CGFloat(index)*self.frame.width
        }
        self.contentSize = CGSize(width: frame.width*CGFloat(viewControllers.count), height: frame.height)
        self.contentOffset.x = CGFloat(pagerReference.getPage()) * self.frame.width
        menuReference.moveIndicator(offsetX: Double(self.contentOffset.x))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagerReference.didSetPage(index: (self.currentPage < viewControllers.count) ? self.currentPage : viewControllers.count-1)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pagerReference.didSetPage(index: (self.currentPage < viewControllers.count) ? self.currentPage : viewControllers.count-1)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagerReference.isSettingPage(index: (self.currentHalfPage < viewControllers.count) ? self.currentHalfPage : viewControllers.count-1)
        menuReference.moveIndicator(offsetX: Double(scrollView.contentOffset.x))
        pagerReference.delegate?.percentageScrolled(percentage: Double(scrollView.contentOffset.x / (CGFloat(viewControllers.count-1) * self.frame.width)))
    }
    
    internal func moveToPage(index: Int, animated: Bool) {
        let myOffset = CGFloat(index)*frame.width
        setContentOffset(CGPoint(x: myOffset, y: 0), animated: animated)
    }
    
    private func createPageFromController(index: Int) {
        if index >= 0 && index < self.viewControllers.count && !self.viewControllers[index].view.isDescendant(of: self) {
            DispatchQueue.main.async {
                self.addSubview(self.viewControllers[index].view)
            }
        }
    }
    
    internal func checkCreatedPages(index: Int) {
        guard !pagerReference.loadAllPages else{
            return
        }
        DispatchQueue.global().async {
            for i in index-self.pagerReference.pagesOffLimit...index+self.pagerReference.pagesOffLimit {
                self.createPageFromController(index: i)
            }
        }
    }
}

internal extension BodyView {
    var currentPage:Int{
        return Int(self.contentOffset.x/self.frame.width)
    }
    
    var currentHalfPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
