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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        runnerImageView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        runnerImageView.makeCircle(ofRadius: runnerImageView.frame.width)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}