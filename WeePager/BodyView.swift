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
    var viewControllers : [UIViewController] = [UIViewController]()
    var infiniteViewControllers : [UIViewController] = [UIViewController]()
    var menuReference: MenuView?
    var pagerReference: WeePager!
    
    init(frame: CGRect, viewControllers: [UIViewController], pagerReference: WeePager) {
        super.init(frame: frame)
        
        self.pagerReference = pagerReference
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.clipsToBounds = pagerReference.clipsToBounds
        self.isScrollEnabled = pagerReference.bodyScrollable
        self.bounces = pagerReference.bodyBounceable
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
        //setup infiniteScroll
        guard !pagerReference.infiniteScroll else {
            updateLayoutInfiniteScroll()
            return
        }
        
        for elem in viewControllers {
            let index = viewControllers.index(of: elem)!
            elem.view.frame.size = self.frame.size
            elem.view.frame.origin.x = CGFloat(index)*self.frame.width
        }
        self.contentSize = CGSize(width: frame.width*CGFloat(viewControllers.count), height: 1.0)
        self.contentOffset.x = CGFloat(pagerReference.getPage()) * self.frame.width
        menuReference?.moveIndicator(offsetX: Double(self.contentOffset.x))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Scroll Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pagerReference.delegate?.pagerWillBeginMoving?(fromIndex: self.currentPage)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !pagerReference.infiniteScroll else {
            pagerReference.didSetPage(index: pagerReference.getPage())
            return
        }
        pagerReference.didSetPage(index: (self.currentPage < viewControllers.count) ? self.currentPage : viewControllers.count-1)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard !pagerReference.infiniteScroll else {
            pagerReference.didSetPage(index: pagerReference.getPage())
            return
        }
        pagerReference.didSetPage(index: (self.currentPage < viewControllers.count) ? self.currentPage : viewControllers.count-1)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !pagerReference.infiniteScroll {
            pagerReference.isSettingPage(index: (self.currentHalfPage < viewControllers.count) ? self.currentHalfPage : viewControllers.count-1)
            menuReference?.moveIndicator(offsetX: Double(scrollView.contentOffset.x))
        } else {
            pagerReference.isSettingPage(index: self.currentHalfPageInfinite)
        }
        pagerReference.delegate?.percentageScrolled?(percentage: Double(scrollView.contentOffset.x / (CGFloat(viewControllers.count-1) * self.frame.width)))
    }
    
    //MARK: Pages Management
    internal func moveToPage(index: Int, animated: Bool) {
        let myOffset = CGFloat(index)*frame.width
        setContentOffset(CGPoint(x: myOffset, y: 0), animated: animated)
    }
    
    private func createPageFromController(index: Int) {
        if index >= 0 && index < self.viewControllers.count && !self.viewControllers[index].view.isDescendant(of: self) {
            self.addSubview(self.viewControllers[index].view)
        }
    }
    
    internal func checkCreatedPages(index: Int) {
        guard !pagerReference.loadAllPages else{
            return
        }
        DispatchQueue.main.async {
            for i in index-self.pagerReference.pagesOffLimit...index+self.pagerReference.pagesOffLimit {
                self.createPageFromController(index: i)
            }
        }
    }
    
    //MARK: Infinite Scroll
    func updateLayoutInfiniteScroll() {
        let selectedVC = viewControllers[pagerReference.getPage()]
        let halfCount = (viewControllers.count - 1)/2
        var vcRightArr: [UIViewController] = []
        var vcLeftArr: [UIViewController] = []
        
        //rightArr
        if pagerReference.getPage() + halfCount < viewControllers.count {
            for i in 1...halfCount {
                vcRightArr.append(viewControllers[pagerReference.getPage()+i])
            }
        } else {
            let diff = pagerReference.getPage() + halfCount - viewControllers.count
            for i in 1..<halfCount-diff {
                vcRightArr.append(viewControllers[pagerReference.getPage()+i])
            }
            for i in 0...diff {
                vcRightArr.append(viewControllers[i])
            }
        }
        
        //leftArr
        if pagerReference.getPage() - halfCount >= 0 {
            for i in 1...halfCount {
                vcLeftArr.append(viewControllers[pagerReference.getPage()-i])
            }
        } else {
            let diff = pagerReference.getPage() - halfCount
            for i in (0..<pagerReference.getPage()).reversed() {
                vcLeftArr.append(viewControllers[i])
            }
            for i in (viewControllers.count+diff..<viewControllers.count).reversed() {
                vcLeftArr.append(viewControllers[i])
            }
        }
        
        infiniteViewControllers = vcLeftArr.reversed() + [selectedVC] + vcRightArr
        
        selectedVC.view.frame.size = self.frame.size
        selectedVC.view.frame.origin.x = 0
        
        for elem in vcRightArr {
            let index = vcRightArr.index(of: elem)! + 1
            elem.view.frame.size = self.frame.size
            elem.view.frame.origin.x = CGFloat(index)*self.frame.width
        }
        
        for elem in vcLeftArr.reversed() {
            let index = vcLeftArr.index(of: elem)! + 1
            elem.view.frame.size = self.frame.size
            elem.view.frame.origin.x = -CGFloat(index)*self.frame.width
        }
        self.contentInset = UIEdgeInsetsMake(0, CGFloat(vcLeftArr.count)*self.frame.width, 0, 0)
        self.contentSize = CGSize(width: frame.width*CGFloat(vcRightArr.count), height: frame.height)
        self.contentOffset.x = 0
        pagerReference.bodyOldIndex = 0
    }
    
    internal func updateInfiniteViewControllersPosition(forward: Bool) {
        guard !forward else {
            let firstVc = infiniteViewControllers.remove(at: 0)
            firstVc.view.frame.origin.x = infiniteViewControllers.last!.view.frame.origin.x + self.frame.width
            infiniteViewControllers.append(firstVc)
            
            self.contentSize = CGSize(width: self.contentSize.width+self.frame.width, height: self.contentSize.height)
            return
        }
        let lastVc = infiniteViewControllers.remove(at: infiniteViewControllers.count-1)
        lastVc.view.frame.origin.x = infiniteViewControllers.first!.view.frame.origin.x - self.frame.width
        infiniteViewControllers.insert(lastVc, at: 0)
        
        self.contentInset = UIEdgeInsetsMake(0, self.contentInset.left+self.frame.width, 0, 0)
    }
}

internal extension BodyView {
    var currentPage:Int{
        return Int(self.contentOffset.x/self.frame.width)
    }
    
    var currentHalfPage:Int {
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
    
    var currentHalfPageInfinite:Int {
        if self.contentOffset.x < 0 {
            return Int((self.contentOffset.x+(-0.5*self.frame.size.width))/self.frame.width)
        }
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
