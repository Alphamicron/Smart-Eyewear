//
//  OthersVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/10/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class OthersVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavOthersWhite"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
