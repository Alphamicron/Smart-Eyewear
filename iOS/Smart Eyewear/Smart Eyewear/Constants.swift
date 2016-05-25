//
//  Constants.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import Foundation
struct Constants
{
    static let deviceFullChargeValue: NSNumber = 100
    static let defaultTimeOut: NSTimeInterval = 15
    static let defaultDelayTime: NSTimeInterval = 2.0
    
    static func defaultErrorAlert(errorTitle: String, errorMessage: String)->UIAlertController
    {
        let defaultAlertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        defaultAlertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        return defaultAlertController
    }
}