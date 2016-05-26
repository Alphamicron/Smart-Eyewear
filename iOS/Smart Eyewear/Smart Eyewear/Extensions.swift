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
        
        // String format guide https://goo.gl/16mDzc
        return String(format: "#%02lX%02lX%02lX", lroundf(redComponent * 255), lroundf(greenComponent * 255), lroundf(blueComponent * 255))
    }
}