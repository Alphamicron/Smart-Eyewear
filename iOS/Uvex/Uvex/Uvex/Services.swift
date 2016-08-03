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
    var serviceName: ServiceType
}

class Services
{
    private var allServices: [ServiceType:[Service]] = [:]
    
    private static let sharedInstance: Services = Services()
    
    private init()
    {
        addServices()
    }
    
    private func addServices()
    {
        // Eyewear Services
        let batteryLevel: Service = Service(serviceIcon: UIImage(named: "Battery")!, serviceName: .Eyewear)
        let manualMode: Service = Service(serviceIcon: UIImage(named: "ManualBtn")!, serviceName: .Eyewear)
        let autoMode: Service = Service(serviceIcon: UIImage(named: "AutomaticBtn")!, serviceName: .Eyewear)
        
        let allEyewearServices: [Service] = [batteryLevel, manualMode, autoMode]
        
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