//
//  UIView+Extension.swift
//  SnpachatSwipeViewWithScrollView
//
//  Created by Zark on 2019/6/4.
//  Copyright © 2019 Zark. All rights reserved.
//

import UIKit

extension UIView {
    func setViewTopRaidus(radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.layer.cornerRadius = radius
        } else {
            let roundedMaskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let roundedMaskShapeLayer = CAShapeLayer()
            roundedMaskShapeLayer.path = roundedMaskPath.cgPath
            self.layer.mask = roundedMaskShapeLayer
        }
    }
    
    func setViewShadow() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowRadius = 6.0
    }

    func setViewBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 180, green: 180, blue: 180, alpha: 1).cgColor
    }
    
}
