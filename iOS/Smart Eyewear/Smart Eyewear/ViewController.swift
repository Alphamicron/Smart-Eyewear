//
//  ViewController.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // POST: Delays any operation for 'delayTime' duration. Time is in seconds.
    static func delayFor(delayTime: Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

}

