//
//  SampleVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/15/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class SampleVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Back"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("VWA called")
        
        MainPageVC.activateScroll(false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        print("VDA called")
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        print("VWD called")
        
        MainPageVC.activateScroll(true)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        print("VDD called")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
