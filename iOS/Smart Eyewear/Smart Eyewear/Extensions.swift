//
//  Extensions.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
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