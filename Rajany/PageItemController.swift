//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by olxios on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    @IBAction func btnSkip(_ sender: AnyObject) {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(true, forKey: "Status")
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = loginViewController
        appDelegate.window!.makeKeyAndVisible()
    }
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
    }
}
