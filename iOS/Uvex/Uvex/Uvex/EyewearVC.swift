//
//  EyeWearVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/25/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import AVFoundation

class EyeWearVC: UIViewController
{
    @IBOutlet weak var playerView: UIView!
    
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    lazy var playerLayer:AVPlayerLayer = {
        
        let player = AVPlayer(URL:  NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("videoplayback", ofType: "mp4")!))
        player.muted = true
        player.allowsExternalPlayback = false
        player.appliesMediaSelectionCriteriaAutomatically = false
        var error:NSError?
        
        // This is needed so it would not cut off users audio; if listening to music etc.
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        }
        catch var error1 as NSError
        {
            error = error1
        }
        catch
        {
            fatalError()
        }
        if error != nil
        {
            print(error)
        }
        
        var playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.getCircleFrame()
        playerLayer.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        playerLayer.backgroundColor = UIColor.blackColor().CGColor
        player.play()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(EyeWearVC.playerDidReachEnd), name:AVPlayerItemDidPlayToEndTimeNotification, object:nil)
        return playerLayer
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.playerView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        self.playerView.makeCircle(ofRadius: playerView.frame.width)
        self.playerView.layer.addSublayer(self.playerLayer)
        
        tapGesture.addTarget(self, action: #selector(EyeWearVC.userTappedView(_:)))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // If orientation changes
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        playerLayer.frame = self.getCircleFrame()
    }
    
    func playerDidReachEnd()
    {
        self.playerLayer.player!.seekToTime(kCMTimeZero)
        self.playerLayer.player!.play()
    }
    
    func getCircleFrame()->CGRect
    {
        return playerView.bounds
    }
    
    func userTappedView(sender: UITapGestureRecognizer)
    {
        performSegueWithIdentifier("segueToEyeWearTVC", sender: nil)
    }
}
