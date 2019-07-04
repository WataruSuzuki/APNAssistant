//
//  UtilAppStatus.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAppStatus: NSObject {

    var indicator: UIActivityIndicatorView!
    
    func getIndicatorFrame(_ scrollView: UIScrollView) -> CGRect {
        return CGRect(origin: scrollView.contentOffset, size: scrollView.frame.size)
    }
    
    func startIndicator(_ currentView: UIScrollView) {
        indicator = UIActivityIndicatorView(frame: getIndicatorFrame(currentView))
        //indicator.center = self.view.center
        indicator.alpha = 0.5
        if #available(iOS 13.0, *) {
            indicator.backgroundColor = .systemBackground
            indicator.activityIndicatorViewStyle = .large
        } else {
            indicator.backgroundColor = .gray
            indicator.activityIndicatorViewStyle = .whiteLarge
        }
        indicator.startAnimating()
        currentView.addSubview(indicator)
    }
    
    func stopIndicator() {
        indicator.removeFromSuperview()
    }
    
}
