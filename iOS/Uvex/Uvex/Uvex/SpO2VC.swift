//
//  SpO2VC.swift
//  Uvex
//
//  Created by Alphamicron on 8/19/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class SpO2VC: UIViewController
{
    @IBOutlet weak var lungsImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lungsImageView.image = Lungs.imageOfSlice1(size: lungsImageView.bounds.size, resizing: Lungs.ResizingBehavior.AspectFit)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
