//
//  CustomUISlider.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/10/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class CustomUISlider : UISlider
{
    //    override func trackRectForBounds(bounds: CGRect) -> CGRect
    //    {
    //        // keeps original origin and width, changes height
    //        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 100.0))
    //        super.trackRectForBounds(customBounds)
    //        
    //        return customBounds
    //    }
    
    override func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect
    {
        return super.thumbRectForBounds(bounds, trackRect: rect, value: value)
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "customThumb"), forState: .Normal)
        super.awakeFromNib()
    }
}
