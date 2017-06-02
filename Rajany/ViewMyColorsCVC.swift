//
//  ViewController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/20/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class MyColorPost: SafeJsonObject {
    var email: String?
    var red: String?
    var green: String?
    var blue: String?
    var alpha: String?
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
}

class MyColorFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [MyColorPost]()
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.collectionView!.alwaysBounceVertical = true
        collectionView!.addSubview(refresher)
        
        let url = URL(string: "http://amrfarouqa.website/rajdy/get_all_colors_ios.php")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
        
            
            do {
                let prefs:UserDefaults = UserDefaults.standard
                let email:NSString = (prefs.value(forKey: "EMAIL") as? String)! as NSString
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                
                if let postsArray = json["colors"] as? [[String: String]] {
                    
                    self.posts = [MyColorPost]()
                    
                    for postDictionary in postsArray {
                        let post = MyColorPost()
                        post.setValuesForKeys(postDictionary)
                        if(post.email == email as String){
                            self.posts.append(post)
                        }
                    }
                    self.collectionView?.reloadData()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView?.reloadData()
                    })
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                })
                self.collectionView?.reloadData()
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            
            }.resume()
        
        refresh()
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(MyColorFeedCell.self, forCellWithReuseIdentifier: cellId)
        setupNavBarButtons()
        
    }
    
    func setupNavBarButtons() {
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        /*let profile = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
         
         let messages = UIBarButtonItem(image: UIImage(named: "advice")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))*/
        
        /*let logout = UIBarButtonItem(image: UIImage(named: "power")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))*/
        
        
        let back = UIBarButtonItem(image: UIImage(named: "arrowleft")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        
        let navItem = UINavigationItem(title: "Colors")
        //navItem.rightBarButtonItems = [logout]
        navItem.leftBarButtonItem = back
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar);
    }
    
    func handleMore(){
        
    }
    func handleLogout() {
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        let manager = FBSDKLoginManager()
        manager.logOut()
        let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginVC
        appDelegate.window!.makeKeyAndVisible()
    }
    func handleBack(){
        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = HomeVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func refresh()
    {
        self.collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func showProfile() {
        let ProfileCVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = ProfileCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let MyColorFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyColorFeedCell
        
        MyColorFeedCell.post = posts[(indexPath as NSIndexPath).item]
        MyColorFeedCell.feedController = self
        
        return MyColorFeedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

class MyColorFeedCell: UICollectionViewCell {
    
    var feedController: MyColorFeedController?
    
    var post: MyColorPost? {
        didSet {
            if let statusText = post?.email {
                
                statusTextView.text = statusText
                
            }
            
            if let statusImageName = post?.email {
               statusImageView.backgroundColor = UIColor(red: CGFloat(CGFloat(((post?.red)! as NSString).doubleValue)), green: CGFloat(CGFloat(((post?.green)! as NSString).doubleValue)), blue: CGFloat(CGFloat(((post?.blue)! as NSString).doubleValue)), alpha: CGFloat(CGFloat(((post?.alpha)! as NSString).doubleValue)))
                print(statusImageName)
            }
            
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let likeButton: UIButton = FeedCell.buttonForTitle("", imageName: "delete")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func deleteColor(){
           }
    
    
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likeButton)
        addSubview(dividerLineView)
        addConstraintsWithFormat("V:[v0(450)]|", views: statusImageView)
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: likeButton, statusTextView )
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat("V:|-12-[v0]", views: likeButton)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        likeButton.addTarget(self,action:#selector(deleteColor), for:.touchUpInside)
    }
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        return textView
    }()
    
}

