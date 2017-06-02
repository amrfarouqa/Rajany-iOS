//
//  ChatLogController.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: UserChat? {
        didSet {
            navigationItem.title = user?.username
            observeMessages()
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.sizeToFit()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func back() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.present(vc, animated: true, completion: nil)
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        let userMessagesRef = FIRDatabase.database().reference().child("messages")
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        setupKeyboardObservers()
        checkIfUserIsLoggedIn()
        
        
        
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.chatLogController = self
        return chatInputContainerView
    }()
    
    func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child(FIRAuth.auth()!.currentUser!.uid).child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
            
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardDidShow() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey])! as AnyObject).cgRectValue
        let keyboardDuration = (((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey])! as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey])! as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[(indexPath as NSIndexPath).item]
        
        cell.message = message
        
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        if let text = message.text {
            //a text message
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
       /* if let profileImageUrl =  FIRAuth.auth()?.currentUser?.photoURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(String(profileImageUrl))
        }*/
        if message.photoUrl != nil {
            cell.profileImageView.loadImageUsingCacheWithUrlString(message.photoUrl!)
        }else{
            cell.profileImageView.loadImageUsingCacheWithUrlString(String("http://amrfarouqa.website/rajdy/main/img/icons/avatar.png"))
        }
        
        //outgoing blue
        cell.bubbleView.backgroundColor =  UIColor.blue
        cell.textView.textColor = UIColor.white
        cell.profileImageView.isHidden = false
        
        cell.bubbleViewRightAnchor?.isActive = false
        cell.bubbleViewLeftAnchor?.isActive = true
        
        if message.name != nil {
            cell.usernameTextView.text = message.name
        }
        
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[(indexPath as NSIndexPath).item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleSend() {
        if let text = inputContainerView.inputTextField.text, !text.isEmpty{
            //do something if it's not empty
           sendMessageWithProperties(inputeText: text)
        }else{
            
        }
        
    }
    
    func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        if let username = FIRAuth.auth()?.currentUser?.displayName, let photoUrl = FIRAuth.auth()?.currentUser?.photoURL{
            let values: [String: AnyObject] = ["name":username as AnyObject, "photoUrl": String(describing: photoUrl) as AnyObject, "imageUrl": String(imageUrl) as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                self.inputContainerView.inputTextField.text = nil
                
            }
        }else{
            let values: [String: AnyObject] = ["name": (FIRAuth.auth()?.currentUser?.email)! as AnyObject, "photoUrl": "http://amrfarouqa.website/rajdy/main/img/icons/avatar.png" as AnyObject,"imageUrl": String(imageUrl) as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                self.inputContainerView.inputTextField.text = nil
                
            }
        }
    }
    
    func sendMessageWithProperties(inputeText: String) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        if let username = FIRAuth.auth()?.currentUser?.displayName, let photoUrl = FIRAuth.auth()?.currentUser?.photoURL{
            let values: [String: AnyObject] = ["name":username as AnyObject, "photoUrl": String(describing: photoUrl) as AnyObject, "text": inputeText as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                self.inputContainerView.inputTextField.text = nil
                
            }
        }else{
            let values: [String: AnyObject] = ["name": (FIRAuth.auth()?.currentUser?.email)! as AnyObject, "photoUrl": "http://amrfarouqa.website/rajdy/main/img/icons/avatar.png" as AnyObject, "text": inputeText as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                self.inputContainerView.inputTextField.text = nil
                
            }
        }
    }
    
        var startingFrame: CGRect?
        var blackBackgroundView: UIView?
        var startingImageView: UIImageView?
        
        //my custom zooming logic
        func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            let zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView.backgroundColor = UIColor.red
            zoomingImageView.image = startingImageView.image
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            if let keyWindow = UIApplication.shared.keyWindow {
                blackBackgroundView = UIView(frame: keyWindow.frame)
                blackBackgroundView?.backgroundColor = UIColor.black
                blackBackgroundView?.alpha = 0
                keyWindow.addSubview(blackBackgroundView!)
                
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.blackBackgroundView?.alpha = 1
                    self.inputContainerView.alpha = 0
                    
                    // math?
                    // h2 / w1 = h1 / w1
                    // h2 = h1 / w1 * w1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    
                    zoomingImageView.center = keyWindow.center
                    
                    }, completion: { (completed) in
                        //                    do nothing
                })
                
            }
        }
        
        func checkIfUserIsLoggedIn() {
            if FIRAuth.auth()?.currentUser?.uid == nil {
                
            } else {
                fetchUserAndSetupNavBarTitle()
            }
        }
        
        func fetchUserAndSetupNavBarTitle() {
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                //for some reason uid = nil
                return
            }
            
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let user = UserChat()
                    user.setValuesForKeys(dictionary)
                    
                }
                
                }, withCancel: nil)
        }
        
        
        
        
        func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
            if let zoomOutImageView = tapGesture.view {
                //need to animate back out to controller
                zoomOutImageView.layer.cornerRadius = 16
                zoomOutImageView.clipsToBounds = true
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    zoomOutImageView.frame = self.startingFrame!
                    self.blackBackgroundView?.alpha = 0
                    self.inputContainerView.alpha = 1
                    
                    }, completion: { (completed) in
                        zoomOutImageView.removeFromSuperview()
                        self.startingImageView?.isHidden = false
                })
            }
        }
}
