//
//  ProgramLEDVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class ProgramLEDVC: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
