//
//  Extensions.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Foundation

// MARK: UILabel Extension
// POST: Adds character spacing to assigned text
// Credit: Andrew Schreiber http://stackoverflow.com/a/34757069
extension UILabel
{
    @IBInspectable var kerning: Float
        {
        get
        {
            var range = NSMakeRange(0, (text ?? "").characters.count)
            guard let kern = attributedText?.attribute(NSKernAttributeName, atIndex: 0, effectiveRange: &range),
                value = kern as? NSNumber
                
                else
            {
                return 0
            }
            return value.floatValue
        }
        set
        {
            var attText:NSMutableAttributedString?
            
            if let attributedText = attributedText
            {
                attText = NSMutableAttributedString(attributedString: attributedText)
            }
            else if let text = text
            {
                attText = NSMutableAttributedString(string: text)
            }
            else
            {
                attText = NSMutableAttributedString(string: "")
            }
            
            let range = NSMakeRange(0, attText!.length)
            attText!.addAttribute(NSKernAttributeName, value: NSNumber(float: newValue), range: range)
            self.attributedText = attText
        }
    }
}

extension UIView
{
    func makeCircle(ofRadius newSize: CGFloat)
    {
        let circleCenter: CGPoint = self.center
        let newCircleFrame: CGRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize, newSize)
        self.frame = newCircleFrame
        self.layer.cornerRadius = newSize / 2.0
        self.center = circleCenter
    }
}