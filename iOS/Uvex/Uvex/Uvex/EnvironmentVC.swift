//
//  EnvironmentVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class EnvironmentVC: UIViewController
{
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var environmentImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        environmentImageView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        environmentImageView.makeCircle(ofRadius: environmentImageView.frame.width)
        
        tapGesture.addTarget(self, action: #selector(EnvironmentVC.userTappedView(_:)))
        environmentImageView.addGestureRecognizer(tapGesture)
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
            performSegueWithIdentifier("segueToEnvironmentTVC", sender: nil)
        }
    }
}
