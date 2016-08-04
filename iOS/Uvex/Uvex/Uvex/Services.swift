//
//  Services.swift
//  Uvex
//
//  Created by Alphamicron on 8/3/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Foundation

enum ServiceType
{
    case Eyewear
    case Fitness
    case Health
    case Environment
}

struct Service
{
    var serviceIcon: UIImage
    var serviceName: String
}

class Services
{
    static let sharedInstance: Services = Services()
    private var allServices: [ServiceType:[Service]] = [:]
    
    private init()
    {
        addServices()
    }
    
    private func addServices()
    {
        // Eyewear Services
        let batteryLevel: Service = Service(serviceIcon: UIImage(named: "Battery")!, serviceName: "Battery Level")
        let autoMode: Service = Service(serviceIcon: UIImage(named: "AutomaticBtn")!, serviceName: "Automatic")
        let manualMode: Service = Service(serviceIcon: UIImage(named: "ManualBtn")!, serviceName: "Manual")
        
        let allEyewearServices: [Service] = [batteryLevel, autoMode, manualMode]
        
        allServices[.Eyewear] = allEyewearServices
    }
    
    func getAllServices(under serviceType: ServiceType)-> [Service]
    {
        switch serviceType
        {
        case .Environment: return allServices[.Environment]!
        case .Eyewear: return allServices[.Eyewear]!
        case .Fitness: return allServices[.Fitness]!
        case .Health: return allServices[.Health]!
        }
    }
}