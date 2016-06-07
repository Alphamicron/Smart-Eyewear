//
//  Modal.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/7/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import Foundation

// MARK: Services currently supported
struct Services
{
    var serviceIcons: [UIImage] = [UIImage]()
    var serviceName: String = String()
    
    init(newserviceName: String, newServiceIcon: [UIImage])
    {
        serviceName = newserviceName
        serviceIcons = newServiceIcon
    }
    
    static func getServices()->[Services]
    {
        var totalServices: [Services] = [Services]()
        
        // the first image is the original one and the second one is used when the cell is selected
        totalServices.append(Services(newserviceName: "Connection", newServiceIcon: [UIImage(named: "Bluetooth")!, UIImage(named: "BluetoothWhite")!]))
        totalServices.append(Services(newserviceName: "RGB LEDs", newServiceIcon: [UIImage(named: "RGBLed")!, UIImage(named: "RGBLedWhite")!]))
        totalServices.append(Services(newserviceName: "Activation", newServiceIcon: [UIImage(named: "Goggles")!, UIImage(named: "GogglesWhite")!]))
        totalServices.append(Services(newserviceName: "Battery Level", newServiceIcon: [UIImage(named: "Battery")!, UIImage(named: "BatteryWhite")!]))
        totalServices.append(Services(newserviceName: "Others", newServiceIcon: [UIImage(named: "Other")!, UIImage(named: "OtherWhite")!]))
        
        return totalServices
    }
}