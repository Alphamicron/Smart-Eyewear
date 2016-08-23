//
//  HealthVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class HealthVC: UIViewController
{
    @IBOutlet weak var healthImageView: UIImageView!
    
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        healthImageView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        healthImageView.makeCircle(ofRadius: healthImageView.frame.width)
        
        tapGesture.addTarget(self, action: #selector(HealthVC.userTappedView(_:)))
        healthImageView.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userTappedView(sender: UITapGestureRecognizer)
    {
        if !Constants.isDeviceConnected()
        {
            Constants.defaultNoDeviceAlert(On: self)
        }
        else
        {
            performSegueWithIdentifier("segueToHealthTVC", sender: nil)
        }
    }
}