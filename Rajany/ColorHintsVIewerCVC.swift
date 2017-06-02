//
//  ViewController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/20/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
class HintsVPost: SafeJsonObject {
    var email: String?
    var username: String?
    var date: String?
    var hint: String?
    var key: String?
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
}

class HintsVFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [HintsVPost]()
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.collectionView!.alwaysBounceVertical = true
        collectionView!.addSubview(refresher)
        
        let useruid = FIRAuth.auth()?.currentUser?.uid
        let ideasRef = FIRDatabase.database().reference().child("colorhints").child(useruid!)
        
        ideasRef.observe(.childAdded, with: { (snapshot) in
            let post = HintsVPost()
            if let dictionary = snapshot.value as? NSDictionary {
                
                if let username = dictionary["username"] as? String, let email = dictionary["email"] as? String, let hint = dictionary["hint"] as? String, let date = dictionary["date"] as? String {
                    post.setValue(username as AnyObject?, forKey: "username")
                    post.setValue(email as AnyObject?, forKey: "email")
                    post.setValue(hint as AnyObject?, forKey: "hint")
                    post.setValue(date as AnyObject?, forKey: "date")
                    post.setValue(snapshot.key as AnyObject?, forKey: "key")
                    self.posts.append(post)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView?.reloadData()
                    })
                    self.collectionView?.reloadData()
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                })
                self.collectionView?.reloadData()
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionView?.reloadData()
            })
            self.collectionView?.reloadData()
            
        }, withCancel: nil)
        
        
        self.collectionView?.reloadData()
        
        refresh()
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(HintsVFeedCell.self, forCellWithReuseIdentifier: cellId)
        setupNavBarButtons()
        
    }
    
    func setupNavBarButtons() {
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        /*let profile = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
         
         let messages = UIBarButtonItem(image: UIImage(named: "advice")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))*/
        
        /*let logout = UIBarButtonItem(image: UIImage(named: "power")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))*/
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        let navItem = UINavigationItem(title: "Hints Viewer")
        //navItem.rightBarButtonItems = [logout]
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
        let HintsVFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HintsVFeedCell
        
        HintsVFeedCell.post = posts[(indexPath as NSIndexPath).item]
        HintsVFeedCell.feedController = self
        
        return HintsVFeedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

class HintsVFeedCell: UICollectionViewCell {
    
    var feedController: HintsVFeedController?
    
    var post: HintsVPost? {
        didSet {
            if let statusText = post?.date {
                
                statusTextView.text = statusText
                
            }
            if let statusImageName = post?.hint {
                statusImageView.loadImageUsingUrlString(statusImageName)
                
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
    
    func deleteItem(){
        let alert = UIAlertController(title: "Rajany", message:"Are You Sure You Want To Delete Color Hint?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Ideabook Deleting Canceled")
        }))
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            FIRDatabase.database().reference()
                .child("colorhints")
                .child(FIRAuth.auth()!.currentUser!.uid)
                .child((self.post?.key)!)
                .removeValue()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! HomeVC
            self.feedController?.present(vc, animated: true, completion: nil)
        })
        self.feedController?.present(alert, animated: true){};
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
        likeButton.addTarget(self,action:#selector(deleteItem), for:.touchUpInside)
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

