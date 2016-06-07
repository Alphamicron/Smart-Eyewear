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
    var serviceIcon: UIImage = UIImage()
    var serviceName: String = String()
    
    init(newserviceName: String, newServiceIcon: UIImage)
    {
        serviceName = newserviceName
        serviceIcon = newServiceIcon
    }
    
    static func getServices()->[Services]
    {
        var totalServices: [Services] = [Services]()
        
        totalServices.append(Services(newserviceName: "Connection", newServiceIcon: UIImage(named: "Bluetooth")!))
        totalServices.append(Services(newserviceName: "RGB LEDs", newServiceIcon: UIImage(named: "RGBLed")!))
        totalServices.append(Services(newserviceName: "Activation", newServiceIcon: UIImage(named: "Goggles")!))
        totalServices.append(Services(newserviceName: "Battery Level", newServiceIcon: UIImage(named: "Battery")!))
        totalServices.append(Services(newserviceName: "Others", newServiceIcon: UIImage(named: "Other")!))
        
        return totalServices
    }
}