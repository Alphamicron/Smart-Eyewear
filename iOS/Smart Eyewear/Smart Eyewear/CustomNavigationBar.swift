//
//  CustomNavigationBar.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/10/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

/*
 * This solution was provided by Jung-Shuo Pai on S/O
 * http://stackoverflow.com/a/33408704 or https://goo.gl/l7ZMEa
 */

class CustomNavigationBar: UINavigationBar
{
    static let navigationBarHeight: CGFloat = 100
    
    // The difference between new height and default height
    static let heightIncrease:CGFloat = navigationBarHeight - 44
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize()
    {
        let shift = CustomNavigationBar.heightIncrease/2
        
        // Transform all view to shift upward for [shift] point
        self.transform =
            CGAffineTransformMakeTranslation(0, -shift)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shift = CustomNavigationBar.heightIncrease/2
        
        // Move the background down for [shift] point
        let classNamesToReposition: [String] = ["_UINavigationBarBackground"]
        for view: UIView in self.subviews {
            if classNamesToReposition.contains(NSStringFromClass(view.dynamicType))
            {
                let bounds: CGRect = self.bounds
                var frame: CGRect = view.frame
                frame.origin.y = bounds.origin.y + shift - 20.0
                frame.size.height = bounds.size.height + 20.0
                view.frame = frame
            }
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize
    {
        let amendedSize:CGSize = super.sizeThatFits(size)
        let newSize:CGSize = CGSizeMake(amendedSize.width, CustomNavigationBar.navigationBarHeight);
        return newSize;
    }
    
}
