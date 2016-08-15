//
//  ConnectionVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/15/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class ConnectionVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        MainPageVC.activateScroll(false)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        MainPageVC.activateScroll(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
