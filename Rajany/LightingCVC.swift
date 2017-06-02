//
//  ViewController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/20/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
class LightingPost: SafeJsonObject {
    var item: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
}

class LightingFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [LightingPost]()
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.collectionView!.alwaysBounceVertical = true
        collectionView!.addSubview(refresher)
        
        let url = URL(string: AppConfig.lighting_feed)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            
            do {
                /*let prefs:UserDefaults = UserDefaults.standard
                 let email:NSString = (prefs.value(forKey: "EMAIL") as? String)!*/
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                
                if let postsArray = json["lighting"] as? [[String: String]] {
                    
                    self.posts = [LightingPost]()
                    
                    for postDictionary in postsArray {
                        let post = LightingPost()
                        post.setValuesForKeys(postDictionary)
                        self.posts.append(post)
                    }
                    self.collectionView?.reloadData()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView?.reloadData()
                    })
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                })
            } catch let jsonError {
                print(jsonError)
            }
            
            
            
            }.resume()
        
        refresh()
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(LightingFeedCell.self, forCellWithReuseIdentifier: cellId)
        setupNavBarButtons()
        
    }
    
    func setupNavBarButtons() {
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        /*let profile = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
         
         let messages = UIBarButtonItem(image: UIImage(named: "advice")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))*/
        
        /*let logout = UIBarButtonItem(image: UIImage(named: "power")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))*/
        
        /*let title = UIBarButtonItem(title: "Rajany", style: .plain, target: self, action: #selector(handleMore))
         
         let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))*/
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        let navItem = UINavigationItem(title: "Lighting Ideas")
        navItem.leftBarButtonItem = back
        navItem.rightBarButtonItem = logo
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar);
    }
    
    
    
    func handleMore(){
        
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let LightingFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LightingFeedCell
        
        LightingFeedCell.post = posts[(indexPath as NSIndexPath).item]
        LightingFeedCell.feedController = self
        
        return LightingFeedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

class LightingFeedCell: UICollectionViewCell {
    var ref: FIRDatabaseReference!
    var feedController: LightingFeedController?
    
    var post: LightingPost? {
        didSet {
            if let statusText = post?.item {
                
                statusTextView.text = statusText
                
            }
            if let statusImageName = post?.item {
                statusImageView.loadImageUsingUrlString(statusImageName)
                
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        ref =  FIRDatabase.database().reference()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let likeButton: UIButton = LightingFeedCell.buttonForTitle("", imageName: "like")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func addIdea(){
        if let user = FIRAuth.auth()?.currentUser {
            let interval = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/M/yyyy, H:mm"
            let date = formatter.string(from: interval as Date)
            let uid = user.uid
            let email = user.email
            let username = user.displayName
            
            if username != nil {
                let idea = ["date": String(describing: date),
                            "email": String(describing: email!),
                            "idea": String(describing: (self.post?.item)!),
                            "username": String(describing: username)]
                
                ref.child("ideas").child(uid).childByAutoId().setValue(idea)
                let alert = UIAlertController(title: "Success!", message:"Added To Ideabook!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                
                feedController?.present(alert, animated: true){};
            }else{
                let idea = ["date": String(describing: date),
                            "email": String(describing: email!),
                            "idea": String(describing: (self.post?.item)!),
                            "username": "RajanyUser"]
                
                ref.child("ideas").child(uid).childByAutoId().setValue(idea)
                let alert = UIAlertController(title: "Success!", message:"Added To Ideabook!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                
                feedController?.present(alert, animated: true){};
            }
        }
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
        likeButton.addTarget(self,action:#selector(addIdea), for:.touchUpInside)
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

