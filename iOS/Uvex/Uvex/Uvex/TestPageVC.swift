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
        let environmentVC = storyboard!.instantiateViewControllerWithIdentifier("fitness") as! FitnessVC
        
        pages.append(eyeWearVC)
        pages.append(fitnessVC)
        pages.append(healthVC)
        pages.append(environmentVC)
        
        setViewControllers([eyeWearVC], direction: .Forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//    let currentIndex = pages.indexOf(viewController)!
//    let previousIndex = abs((currentIndex - 1) % pages.count)
//    return pages[previousIndex]
//}
//
//func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//    let currentIndex = pages.indexOf(viewController)!
//    let nextIndex = abs((currentIndex + 1) % pages.count)
//    return pages[nextIndex]
//}
//
//func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//    return pages.count
//}
//
//func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//    return 0
//}

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
        let currentIndex: Int = pages.indexOf(viewController)!
        let previousIndex:Int = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let currentIndex: Int = pages.indexOf(viewController)!
        let nextIndex:Int = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
}









