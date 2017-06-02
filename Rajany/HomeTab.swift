//
//  ViewController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/20/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
let cellId = "cellId"

class Post: SafeJsonObject {
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
   

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
}



class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}


class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}

class HomeFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    var refresher:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true
        {
            //        let samplePost = Post()
            //        samplePost.performSelector(Selector("setName:"), withObject: "my name")
            
            self.refresher = UIRefreshControl()
            self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
            self.collectionView!.alwaysBounceVertical = true
            collectionView!.addSubview(refresher)
            
            
            
            let url = URL(string: AppConfig.home_feed)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)  as! [String:Any]
                    
                    
                    if let postsArray = json["posts"] as? [[String: String]] {
                        
                        self.posts = [Post]()
                        
                        for postDictionary in postsArray {
                            let post = Post()
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
            
            
            
            
            
            
            
            collectionView?.contentInset = UIEdgeInsetsMake(90, 0, 50, 0)
            
            collectionView?.alwaysBounceVertical = true
            
            collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
            
            collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
            
            
            
            setupNavBarButtons()
            setupNavBarButtons2()
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }
    }
    
    func refresh()
    {
        self.collectionView?.reloadData()
        refresher.endRefreshing()
    }
    func setupNavBarButtons() {
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        let profile = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showProfile))
        
        let messages = UIBarButtonItem(image: UIImage(named: "advice")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMessage))
        
        let logout = UIBarButtonItem(image: UIImage(named: "power")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        let title = UIBarButtonItem(title: "Rajany", style: .plain, target: self, action: #selector(handleMore))
        
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItems = [logout, profile, messages]
        navItem.leftBarButtonItems = [logo, title]
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar);
    }
    
    func handleMessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = UserChat()
                user.setValuesForKeys(dictionary)
                chatLogController.user = user
            }
            
        }, withCancel: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController(rootViewController: chatLogController)
        appDelegate.window!.makeKeyAndVisible()

    }
    
    func handleLogout() {
        let alert = UIAlertController(title: "Logout", message:"Are You Sure You Want To Logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("HomeViewController Logout Canceled")
        }))
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = LoginVC
            appDelegate.window!.makeKeyAndVisible()
        })
        self.present(alert, animated: true){};
    }
    func handleIdeas(){
        let IdeasCVC = self.storyboard!.instantiateViewController(withIdentifier: "IdeasCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = IdeasCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    
    func setupNavBarButtons2() {
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: 320, height: 44))
        
        let ideabook = UIBarButtonItem(image: UIImage(named: "ideasnav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleIdeas))
        
        
        
        let stories = UIBarButtonItem(image: UIImage(named: "storiesmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showStories))
        
        let advice = UIBarButtonItem(image: UIImage(named: "advicesmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showAdvice))
        
        let navItem = UINavigationItem(title: "")
        
        
        
        navItem.rightBarButtonItems = [stories, advice, ideabook]
        
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar);
    }
    func handleMore() {
        print("Handlemore")
    }
    
    func showStories() {
        let NavGontroller = self.storyboard!.instantiateViewController(withIdentifier: "SNavController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = NavGontroller
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func showProfile() {
        let ProfileCVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = ProfileCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func showAdvice(){
        let NavGontroller = self.storyboard!.instantiateViewController(withIdentifier: "ANavController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = NavGontroller
        appDelegate.window!.makeKeyAndVisible()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[(indexPath as NSIndexPath).item]
        feedCell.feedController = self
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[(indexPath as NSIndexPath).item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeFeedController.zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1
                
                }, completion: nil)
            
        }
    }
    
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
                }, completion: { (didComplete) -> Void in
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })
            
        }
    }
    
}

class FeedCell: UICollectionViewCell {
    
    var feedController: HomeFeedController?
    
    func animate() {
        feedController?.animateImageView(statusImageView)
    }
    
    var post: Post? {
        didSet {
            
            if let name = post?.name {
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                nameLabel.attributedText = attributedText
                
            }
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImagename = post?.profileImageName {
                profileImageView.loadImageUsingUrlString(profileImagename)
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.loadImageUsingUrlString(statusImageName)
                
            }
            
            
            likesCommentsLabel.text = "Post Powered By © Rajany"
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton: UIButton = FeedCell.buttonForTitle("", imageName: "")
    let commentButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    let shareButton: UIButton = FeedCell.buttonForTitle("", imageName: "")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    func handleComment(_ sender:UIButton){
        
    }
        
    
func handleShare(_ sender:UIButton){
    let text = "Powered By © Rajany"
    let url = URL(string: (self.post?.statusImageName)!)!
    
    let objectsToShare: NSArray = [text, url]
    // set up activity view controller
    
    let activityViewController = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
    // present the view controller
    feedController?.present(activityViewController, animated: true, completion: nil)
    
}
func setupViews() {
    backgroundColor = UIColor.white
    
    addSubview(nameLabel)
    addSubview(profileImageView)
    addSubview(statusTextView)
    addSubview(statusImageView)
    addSubview(likesCommentsLabel)
    addSubview(dividerLineView)
    
    addSubview(likeButton)
    addSubview(commentButton)
    addSubview(shareButton)
    
    commentButton.addTarget(self,action:#selector(handleShare),
                            for:.touchUpInside)
    
    
    statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
    
    addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
    
    addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
    
    addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
    
    addConstraintsWithFormat("H:|-12-[v0]|", views: likesCommentsLabel)
    
    addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
    
    //button constraints
    addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
    
    addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
    
    
    
    addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
    
    addConstraintsWithFormat("V:[v0(44)]|", views: commentButton)
    addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
}

}

