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
    @IBOutlet weak var environmentImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        environmentImageView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        environmentImageView.makeCircle(ofRadius: environmentImageView.frame.width)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
