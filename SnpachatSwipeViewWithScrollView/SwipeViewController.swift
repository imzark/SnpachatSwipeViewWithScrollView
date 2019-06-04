//
//  SwipeViewController.swift
//  SnpachatSwipeViewWithScrollView
//
//  Created by Zark on 2019/6/4.
//  Copyright © 2019 Zark. All rights reserved.
//

import UIKit

protocol SwipeViewControllerDataSource {
    func swipeItemViewControllers(in swipeViewController: SwipeViewController) -> [UIViewController]
    func startingIndex(in swipeViewController: SwipeViewController) -> Int
}

@objc protocol SwipeViewControllerDelegate {
    @objc optional func willSwipe()
    @objc optional func didSwipeToIndexOfChildViewControllers(_ index: Int)
    @objc optional func swiping(fromIndex: Int, toIndex: Int, progress: Double)
}

class SwipeViewController: UIViewController {
    
    // protocol 不继承 class 时默认是值类型吗？这里不可以设置 weak
    var dataSource: SwipeViewControllerDataSource?
    var delegate: SwipeViewControllerDelegate?
    
    // childControllers
    private(set) var swipeItemViewControllers = [UIViewController]()
    private(set) var currentSwipeIndex = 0 {
        willSet {
            delegate?.didSwipeToIndexOfChildViewControllers?(newValue)
        }
    }
    var swipeItemCount: Int {
        return swipeItemViewControllers.count
    }
    
    // ScrollView
    private var scrollView: UIScrollView!
    private var currentOffsetX: CGFloat = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
//        horizontalScrollView.isDirectionalLockEnabled = true
        scrollView.clipsToBounds = false // subview 阴影
        scrollView.delegate = self
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        
        guard let _ = dataSource else {
            return
        }
        
        swipeItemViewControllers = dataSource!.swipeItemViewControllers(in: self)
        currentSwipeIndex = dataSource!.startingIndex(in: self)
        
        for index in 0 ..< swipeItemCount {
            let swipeVC = swipeItemViewControllers[index]
            addChild(swipeVC)
            swipeVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width,
                                        y: 0,
                                        width: view.bounds.width,
                                        height: view.bounds.height)
            scrollView.addSubview(swipeVC.view)
            swipeVC.didMove(toParent: self)
        }
        
        scrollView.contentSize = CGSize(
            width: CGFloat(swipeItemCount) * scrollView.bounds.width,
            height: scrollView.bounds.height)
        
        scrollView.contentOffset.x = CGFloat(currentSwipeIndex) * scrollView.contentSize.width
    }
}

// MARK: Swipe Control
extension SwipeViewController {
    func swipeToItemIndex(_ index: Int) {
        guard index < swipeItemCount, index != currentSwipeIndex else {
            return
        }
        UIView.animate(withDuration: 0.15) {
            self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(index)
        }
        currentSwipeIndex = index
    }
}

extension SwipeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = CGFloat(scrollView.frame.width)
        let oldOffsetX = currentOffsetX
        currentOffsetX = scrollView.contentOffset.x
        
        if abs(currentOffsetX - oldOffsetX) >= 2 * pageWidth {
            // 按钮跨越点击, delegate 根据动画时间自定义动画, 不提供 progress 进度了
            return
        }
        
        if currentOffsetX > oldOffsetX {
            // 从左往右
            let fromPageIndex = Int(oldOffsetX / pageWidth)
            let toPageIndex = fromPageIndex + 1
            if fromPageIndex >= 0 && toPageIndex < swipeItemCount {
                delegate?.swiping?(fromIndex: fromPageIndex, toIndex: toPageIndex, progress: Double((currentOffsetX - CGFloat(fromPageIndex) * pageWidth) / pageWidth))
            }
            
        } else if currentOffsetX < oldOffsetX {
            // 从右往左
            let toPageIndex = Int(currentOffsetX / pageWidth)
            let fromPageIndex = toPageIndex + 1
            
            if toPageIndex >= 0 && fromPageIndex < swipeItemCount {
                delegate?.swiping?(fromIndex: fromPageIndex, toIndex: toPageIndex, progress: Double((CGFloat(fromPageIndex) * pageWidth - currentOffsetX) / pageWidth))
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffsetX = scrollView.contentOffset.x
        delegate?.willSwipe?()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 有加速度时, Did End Swipe 时机
        print("swipeVC: SwipeDidEndWithDecelerating")
        currentSwipeIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 无加速度时, Did End Swipe 时机
            // 缓慢拖动无加速度时不会触发 scrollViewDidEndDecelerating 方法，需要用这个方法互相补充
            print("swipeVC: SwipeDidEndWithOutDecelerating")
            currentSwipeIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        }
    }
    
}
