//
//  DistanceVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/23/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Charts

class DistanceVC: UIViewController
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateLabel.text = NSDate().todaysDate
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func timePeriodAction(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0: print("Day is ON")
        case 1: print("Week is ON")
        case 2: print("Month is ON")
        default: break
        }
    }    
}
