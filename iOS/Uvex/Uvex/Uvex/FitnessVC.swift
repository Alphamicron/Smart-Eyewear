//
//  FitnessVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class FitnessVC: UIViewController
{
    @IBOutlet weak var runnerImageView: UIImageView!
    
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        runnerImageView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        runnerImageView.makeCircle(ofRadius: runnerImageView.frame.width)
        
        tapGesture.addTarget(self, action: #selector(FitnessVC.userTappedView(_:)))
        runnerImageView.addGestureRecognizer(tapGesture)
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
            performSegueWithIdentifier("segueToFitnessTVC", sender: nil)
        }
    }
}