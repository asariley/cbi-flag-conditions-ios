//
//  ModelController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 12/25/14.
//  Copyright (c) 2014 Asa Riley. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var controllers: [UIViewController] = []
    var conditionsOpt: UIViewController? = nil
    var notificationPrefsOpt: UIViewController? = nil
    let controllerCount = 2

    //keep references to static pages and load them from main storyboard
    //1. Conditions
    //2. LFG (Future)
    //3. Settings
    //      -switches for notifications, weekend notifications, weekday notifications, evening(5:30pm >) notifications, day notifications, specific colors. Grid the time notifications in a section. Color Section. LFG Section (future)
    //4. Achievement/Certification pages (Future) (perhaps one for each color)
    

    override init() {
        super.init()
        // Create the data model.

        
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
        if index >= self.controllerCount {
            return nil
        }

        // Create a new view controller and pass suitable data.
        if (index == 0) {
            if let controller = conditionsOpt {
                return controller
            } else {
                conditionsOpt = storyboard.instantiateViewControllerWithIdentifier("ConditionsVC") as? UIViewController
                return conditionsOpt
            }
        } else if (index == 1) {
            if let controller = notificationPrefsOpt {
                return controller
            } else {
                notificationPrefsOpt = storyboard.instantiateViewControllerWithIdentifier("NotificationPrefsVC") as? UIViewController
                return notificationPrefsOpt
            }
        } else {
            return nil
        }
    }

    func indexOfViewController(viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        if (viewController is ConditionsViewController) {
            return 0
        } else if (viewController is NotificationPrefsViewController) {
            return 1
        } else {
            return NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index >= self.controllerCount {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

