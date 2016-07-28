//
//  TestPageVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/27/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class TestPageVC: UIPageViewController
{
    var pages: [UIViewController] = [UIViewController]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let eyeWearVC = storyboard!.instantiateViewControllerWithIdentifier("eyeWear") as! EyeWearVC
        let fitnessVC = storyboard!.instantiateViewControllerWithIdentifier("fitness") as! FitnessVC
        let healthVC = storyboard!.instantiateViewControllerWithIdentifier("health") as! HealthVC
        let environmentVC = storyboard!.instantiateViewControllerWithIdentifier("environment") as! EnvironmentVC
        
        pages.append(eyeWearVC)
        pages.append(fitnessVC)
        pages.append(healthVC)
        pages.append(environmentVC)
        
        setViewControllers([eyeWearVC], direction: .Forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(index: Int)-> UIViewController
    {
        if self.pages.count == 0 || index >= self.pages.count
        {
            return UIViewController()
        }
        
        return pages[index]
    }
}

extension TestPageVC: UIPageViewControllerDelegate
{
    
}

extension TestPageVC: UIPageViewControllerDataSource
{
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var currentIndex: Int = pages.indexOf(viewController)!
        
        if currentIndex == 0 || currentIndex == NSNotFound
        {
            return nil
        }
        
        currentIndex -= 1
        return self.viewControllerAtIndex(currentIndex)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var currentIndex: Int = pages.indexOf(viewController)!
        
        if currentIndex == NSNotFound
        {
            return nil
        }
        
        currentIndex += 1
        
        if currentIndex == pages.count
        {
            return nil
        }
        
        return self.viewControllerAtIndex(currentIndex)
    }
}









