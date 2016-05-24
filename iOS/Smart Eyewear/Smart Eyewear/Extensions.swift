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