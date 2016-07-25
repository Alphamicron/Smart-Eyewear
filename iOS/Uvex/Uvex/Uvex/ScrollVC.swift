//
//  ScrollVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class ScrollVC: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    
    let totalNumberOfViews: CGFloat = 4
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Load Controllers
        let eyeWearVC: EyeWearVC = EyeWearVC(nibName: "EyeWearVC", bundle: nil)
        let fitnessVC: FitnessVC = FitnessVC(nibName: "FitnessVC", bundle: nil)
        let healthVC: HealthVC = HealthVC(nibName: "HealthVC", bundle: nil)
        let environmentVC: EnvironmentVC = EnvironmentVC(nibName: "EnvironmentVC", bundle: nil)
        
        // Add them to the scroll view
        self.addChildViewController(eyeWearVC)
        self.scrollView.addSubview(eyeWearVC.view)
        eyeWearVC.didMoveToParentViewController(self)
        
        self.addChildViewController(fitnessVC)
        self.scrollView.addSubview(fitnessVC.view)
        fitnessVC.didMoveToParentViewController(self)
        
        self.addChildViewController(healthVC)
        self.scrollView.addSubview(healthVC.view)
        healthVC.didMoveToParentViewController(self)
        
        self.addChildViewController(environmentVC)
        self.scrollView.addSubview(environmentVC.view)
        environmentVC.didMoveToParentViewController(self)
        
        // Change their scroll start position
        var fitnessVCFrame: CGRect = fitnessVC.view.frame
        fitnessVCFrame.origin.x = self.view.frame.width
        fitnessVC.view.frame = fitnessVCFrame
        
        var healthVCFrame: CGRect = healthVC.view.frame
        healthVCFrame.origin.x = (totalNumberOfViews-2)*self.view.frame.width // multiply by 2
        healthVC.view.frame = healthVCFrame
        
        var environmentVCFrame: CGRect = environmentVC.view.frame
        environmentVCFrame.origin.x = (totalNumberOfViews-1)*self.view.frame.width // multiply by 3
        environmentVC.view.frame = environmentVCFrame
        
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width*totalNumberOfViews, self.view.frame.size.height)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
