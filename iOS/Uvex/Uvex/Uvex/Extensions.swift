//
//  Extensions.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import Foundation
import CoreBluetooth

//MARK: CBPeripheralState Extension
extension CBPeripheralState
{
    func getState()-> String
    {
        switch self
        {
        case .Connected:
            return "Connected"
        case .Connecting:
            return "Connecting"
        case .Disconnected:
            return "Disconnected"
        case .Disconnecting:
            return "Disconnecting"
        }
    }
}

//MARK: CBPeripheralState Extension
extension MBLConnectionState
{
    func getState()-> String
    {
        switch self
        {
        case .Connected:
            return "Connected"
        case .Connecting:
            return "Connecting"
        case .Disconnected:
            return "Disconnected"
        case .Disconnecting:
            return "Disconnecting"
        case .Discovery:
            return "Discovery"
        }
    }
}

//MARK: UIColor Extension
extension UIColor
{
    //POST: Given a colour, returns its repective hex value
    func getHexValue()->String
    {
        let colourComponents = CGColorGetComponents(self.CGColor)
        
        let redComponent: Float = Float(colourComponents[0])
        let greenComponent: Float = Float(colourComponents[1])
        let blueComponent: Float = Float(colourComponents[2])
        
        print("Red Value: \(lroundf(redComponent * 255))")
        print("Green Value: \(lroundf(greenComponent * 255))")
        print("Blue Value: \(lroundf(blueComponent * 255))")
        
        // String format guide https://goo.gl/16mDzc
        return String(format: "#%02lX%02lX%02lX", lroundf(redComponent * 255), lroundf(greenComponent * 255), lroundf(blueComponent * 255))
    }
    
    // POST: Given a colour, returns its RGBA value
    func getRGBAValue()-> (red:Float, green:Float, blue:Float, alpha:Float)?
    {
        var floatRed: CGFloat = CGFloat()
        var floatGreen: CGFloat = CGFloat()
        var floatBlue: CGFloat = CGFloat()
        var floatAlpha: CGFloat = CGFloat()
        
        if self.getRed(&floatRed, green: &floatGreen, blue: &floatBlue, alpha: &floatAlpha)
        {
            return(red: Float(floatRed * 255), green: Float(floatGreen * 255), blue: Float(floatBlue * 255), alpha: Float(floatAlpha * 255))
        }
        else // could not extract the RGBA components
        {
            return nil
        }
    }
}

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

extension UIImageView
{
    override func makeCircle(ofRadius newSize: CGFloat)
    {
        let circleCenter: CGPoint = self.center
        let newCircleFrame: CGRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize, newSize)
        self.frame = newCircleFrame
        self.layer.cornerRadius = newSize / 2.0
        self.center = circleCenter
    }
}

extension NSDate
{
    var todaysDate:String
    {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.stringFromDate(self)
    }
}