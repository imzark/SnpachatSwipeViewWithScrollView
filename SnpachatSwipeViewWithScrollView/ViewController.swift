//
//  ViewController.swift
//  SnpachatSwipeViewWithScrollView
//
//  Created by Zark on 2019/6/4.
//  Copyright © 2019 Zark. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var mainSwipeViewController = SwipeViewController()
    var swipeItemViewControllers = [UIViewController]() // left, mid, right. the mid's view is hidden
    var midViewController: UIViewController!            // the real midView actually

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMidViewController()
        setupSubControllers()
        setupSwipViewController()
        setupBtns()
    }
    
    func setupMidViewController() {
        midViewController = UIViewController()
        midViewController.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        addChild(midViewController)
        midViewController.view.frame = view.bounds
        midViewController.view.isHidden = true
        view.addSubview(midViewController.view)
        midViewController.didMove(toParent: self)
    }
    
    func setupSubControllers() {
        let left = UIViewController()
        left.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        left.view.setViewTopRaidus(radius: 12)
        left.view.setViewShadow()
        
        let mid = UIViewController()
        mid.view.isHidden = true
        
        let right = UIViewController()
        right.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        right.view.setViewTopRaidus(radius: 12)
        right.view.setViewShadow()
        
        swipeItemViewControllers += [left, mid, right]
    }
    
    func setupSwipViewController() {
        mainSwipeViewController.delegate = self
        mainSwipeViewController.dataSource = self
        addChild(mainSwipeViewController)
        mainSwipeViewController.view.frame = CGRect(x: 0, y: 128,
                                                    width: view.bounds.width,
                                                    height: view.bounds.height - 128)
        view.addSubview(mainSwipeViewController.view)
        mainSwipeViewController.didMove(toParent: self)
    }
    
    func setupBtns() {
        let firstBtn = UIButton()
        firstBtn.tag = 0
        let firstBtnImage = UIImage(named: "pinglun")
        firstBtn.setImage(firstBtnImage, for: .normal)
        firstBtn.frame = CGRect(x: (view.bounds.width - 150)/4, y: 700, width: 50, height: 50)
        firstBtn.addTarget(self, action: #selector(scorllToPage(sender:)), for: .touchUpInside)
        
        let secondBtn = UIButton()
        secondBtn.tag = 1
        let secondBtnBtnImage = UIImage(named: "paizhao")
        secondBtn.setImage(secondBtnBtnImage, for: .normal)
        secondBtn.frame = CGRect(x: (view.bounds.width - 150)/4 * 2 + 50, y: 700, width: 50, height: 50)
        secondBtn.addTarget(self, action: #selector(scorllToPage(sender:)), for: .touchUpInside)
        
        let thirdBtn = UIButton()
        thirdBtn.tag = 2
        let thirdBtnImage = UIImage(named: "souyisou")
        thirdBtn.setImage(thirdBtnImage, for: .normal)
        thirdBtn.frame = CGRect(x: (view.bounds.width - 150)/4 * 3 + 100, y: 700, width: 50, height: 50)
        thirdBtn.addTarget(self, action: #selector(scorllToPage(sender:)), for: .touchUpInside)
        
        view.addSubview(firstBtn)
        view.addSubview(secondBtn)
        view.addSubview(thirdBtn)
    }
}

// MARK: Selector
extension ViewController {
    @objc func scorllToPage(sender: UIButton) {
        mainSwipeViewController.swipeToItemIndex(sender.tag)
    }
}

// MARK: SwipeViewControllerDataSource, SwipeViewControllerDelegate
extension ViewController: SwipeViewControllerDataSource, SwipeViewControllerDelegate {
    func swipeItemViewControllers(in swipeViewController: SwipeViewController) -> [UIViewController] {
        return swipeItemViewControllers
    }
    
    func startingIndex(in swipeViewController: SwipeViewController) -> Int {
        return 0
    }
    
    func swiping(fromIndex: Int, toIndex: Int, progress: Double) {
//        print("Swiping from \(fromIndex) To \(toIndex), progress: \(progress*100)%")
        
        // change midView's alpha & hidden
        var midViewAlpha: CGFloat = 0
        
        switch (fromIndex, toIndex) {
        case (0, 1), (2, 1):
            midViewAlpha = CGFloat(progress)
        case (1, 0), (1, 2):
            midViewAlpha = CGFloat(1 - progress)
        default:
            break
        }
        
        midViewController.view.alpha = midViewAlpha
        if midViewAlpha == 0 {
            if !midViewController.view.isHidden {
                print("MainViewController: Hide midView)")
                midViewController.view.isHidden = true
            }
        } else {
            if midViewController.view.isHidden {
                midViewController.view.isHidden = false
                print("MainViewController: Show midView)")
            }
        }
    }
    
    func didSwipeToIndexOfChildViewControllers(_ index: Int) {
        print("MainViewController: Did swipe to index \(index)")
    }
    
}

