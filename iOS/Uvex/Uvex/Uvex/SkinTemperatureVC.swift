//
//  SkinTemperatureVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/19/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class SkinTemperatureVC: UIViewController
{
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humanImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        humanImageView.image = Human.imageOfSlice1(size: humanImageView.bounds.size, resizing: Human.ResizingBehavior.AspectFit)
        
        var start = 0, end = 100
        
        temperatureLabel.text = String(FitnessTVC.randomNumber(from: &start, to: &end))
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}