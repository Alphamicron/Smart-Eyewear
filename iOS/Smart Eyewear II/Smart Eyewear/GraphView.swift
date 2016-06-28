//
//  GraphView.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/28/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

//#define str(index)                                  [NSString stringWithFormat : @"%.f", [[self.values objectAtIndex:(index)] floatValue] * kYScale]
//#define point(x, y)                                 CGPointMake((x) * kXScale, yOffset + (y) * kYScale)
class GraphView: UIView
{
    let kXScale: CGFloat = 15.0
    let kYScale: CGFloat = 50.0
    var timer: dispatch_source_t?
    let GraphColor = UIColor.greenColor()
    var generalYOffset: CGFloat = CGFloat()
    var values: NSMutableArray = NSMutableArray()
    
    func CGAffineTransformMakeScaleTranslate(sx: CGFloat, sy:CGFloat, dx: CGFloat, dy: CGFloat) -> CGAffineTransform
    {
        return CGAffineTransformMake(sx, 0.0, 0.0, sy, dx, dy)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        dispatch_source_cancel(timer!)
    }
    
    override func awakeFromNib()
    {
        self.contentMode = .Right
        self.values = NSMutableArray()
        weak var weakSelf: AnyObject? = self
        let delayInSeconds: Float = 0.25
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        dispatch_source_set_timer(timer!, dispatch_walltime(nil, 0), UInt64(delayInSeconds * Float(NSEC_PER_SEC)), 0)
        dispatch_source_set_event_handler(timer!, {() -> Void in
            weakSelf!.updateValues()
        })
        dispatch_resume(timer!)
        
    }
    
    func updateValues()
    {
        let nextValue: Double = sin(CFAbsoluteTimeGetCurrent()) + (Double(rand()) / Double(RAND_MAX))
        print("new value: \(nextValue)")
        self.values.addObject(Int(nextValue))
        let size: CGSize = self.bounds.size
        
        let maxDimension: CGFloat = size.width
        // MAX(size.height, size.width);
        let maxValues: Int = Int(floor(maxDimension / kXScale))
        print("max. value: \(maxValues)")
        print("array count: \(self.values.count)")
        
        if self.values.count > maxValues
        {
            self.values.removeObjectsInRange(NSMakeRange(0, self.values.count - maxValues))
        }
        self.setNeedsDisplay()
    }
    
    //    convenience func dealloc()
    //    {
    //        dispatch_source_cancel(timer)
    //    }
    
    override func drawRect(rect: CGRect)
    {
        if self.values.count == 0
        {
            return
        }
        
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetStrokeColorWithColor(ctx, GraphColor.CGColor)
        //        CGContextSetLineJoin(ctx, kCGLineJoinRound)
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineWidth(ctx, 2)
        let path: CGMutablePathRef = CGPathCreateMutable()
        let yOffset: CGFloat = self.bounds.size.height / 2
        generalYOffset = yOffset
        var transform: CGAffineTransform = CGAffineTransformMakeScaleTranslate(kXScale, sy: kYScale, dx: 0, dy: yOffset)
        CGPathMoveToPoint(path, &transform, 0, 0)
        CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0)
        var y: CGFloat = CGFloat(self.values[0] as! NSNumber)
        CGPathMoveToPoint(path, &transform, 0, y)
        self.drawAtPoint(point(0, y: y), withStr: str(0))
        
        for x in 1 ..< self.values.count
        {
            y = self.values[x] as! CGFloat
            CGPathAddLineToPoint(path, &transform, CGFloat(x), y)
            self.drawAtPoint(point(CGFloat(x), y: y), withStr: str(x))
        }
        
        CGContextAddPath(ctx, path)
        CGContextStrokePath(ctx)
    }
    
    func drawAtPoint(point: CGPoint, withStr str: String)
    {
        str.drawAtPoint(point, withAttributes: [NSFontAttributeName: Constants.defaultFont.fontWithSize(8), NSStrokeColorAttributeName: GraphColor])
    }
    
    func str(index: Int)-> String
    {
        print("String: \(String(format: "%.f", CGFloat(self.values[index] as! NSNumber) * kYScale))")
        return String(format: "%.f", self.values[index] as! CGFloat * kYScale)
    }
    
    func point(x: CGFloat, y: CGFloat)-> CGPoint
    {
        print("Point: \(CGPointMake(x * kXScale, generalYOffset + y * kYScale))")
        return CGPointMake(x * kXScale, generalYOffset + y * kYScale)
    }
}
