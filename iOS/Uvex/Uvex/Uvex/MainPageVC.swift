//
//  MainPageVC.swift
//  Uvex
//
//  Created by Alphamicron on 7/28/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class MainPageVC: UIPageViewController
{
    var totalPages: [UIViewController] = [UIViewController]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let eyeWearVC = storyboard!.instantiateViewControllerWithIdentifier("eyeWear") as! EyeWearVC
        let fitnessVC = storyboard!.instantiateViewControllerWithIdentifier("fitness") as! FitnessVC
        let healthVC = storyboard!.instantiateViewControllerWithIdentifier("health") as! HealthVC
        let environmentVC = storyboard!.instantiateViewControllerWithIdentifier("environment") as! EnvironmentVC
        
        totalPages.append(eyeWearVC)
        totalPages.append(fitnessVC)
        totalPages.append(healthVC)
        totalPages.append(environmentVC)
        
        setViewControllers([eyeWearVC], direction: .Forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(index: Int)-> UIViewController
    {
        if self.totalPages.count == 0 || index >= self.totalPages.count
        {
            return UIViewController()
        }
        
        return totalPages[index]
    }
}

extension MainPageVC: UIPageViewControllerDelegate
{
    
}

extension MainPageVC: UIPageViewControllerDataSource
{
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return totalPages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var currentIndex: Int = totalPages.indexOf(viewController)!
        
        if currentIndex == 0 || currentIndex == NSNotFound
        {
            return nil
        }
        
        currentIndex -= 1
        
        return self.viewControllerAtIndex(currentIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var currentIndex: Int = totalPages.indexOf(viewController)!
        
        if currentIndex == NSNotFound
        {
            return nil
        }
        
        currentIndex += 1
        
        if currentIndex == totalPages.count
        {
            return nil
        }
        
        return self.viewControllerAtIndex(currentIndex)
    }
}