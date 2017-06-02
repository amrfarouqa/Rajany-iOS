//
//  ViewController.swift
//  Paging_Swift
//
//  Created by olxios on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
   
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private let contentImages = ["slidera",
                                 "sliderb",
                                 "sliderc",
                                 "sliderd"]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupPageControl()
        createPageViewController()
        
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions
    
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentController()
        
        if let controller = pageItemController as? PageItemController {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        
        if (self.pageViewController?.viewControllers?.count)! > 0 {
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
}

extension String {
    func makeFirebaseString()->String{
        let arrCharacterToReplace = [".","#","$","[","]"]
        var finalString = self
        
        for character in arrCharacterToReplace{
            finalString = finalString.replacingOccurrences(of: character, with: " ")
        }
        
        return finalString
    }
}
