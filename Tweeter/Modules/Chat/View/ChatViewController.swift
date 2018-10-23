//
//  ChatViewController.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var mTextPlaceHolder: UILabel!
    @IBOutlet weak var mTextChat: UITextView!
    @IBOutlet weak var mChatBoxBottom: NSLayoutConstraint!
    @IBOutlet weak var mBtnSend: UIButton!
    @IBOutlet weak var mChatList: UICollectionView!
    
    var presenter: IChatPresenter? {
        didSet {
            self.bind()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.unregisterNotification()
    }
    
    func bind() {
        if let presenter = self.presenter,
            let chatList = mChatList,
            let textChat = mTextChat {
            chatList.dataSource = presenter
            chatList.delegate = presenter
            textChat.delegate = presenter
        }
    }
    
    // MARK: Users Actions
    
    @IBAction func btnSend_Click(_ sender: Any) {
        presenter?.send(msg: mTextChat.text)
        clearTextBox()
    }
    
    @IBAction func chatList_Tap(_ sender: UITapGestureRecognizer) {
        if mTextChat.isFirstResponder {
            mTextChat.resignFirstResponder()
        }
    }
}

extension ChatViewController: IChatController {
    
    func notifyDataChanged() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        mChatList.reloadData()
        perform(#selector(scrollToBottom), with: nil, afterDelay: 0.2)
    }
    
    func updateChatBox(text str: String) {
        let available = str.count > 0
        mBtnSend.isEnabled = available
        mTextPlaceHolder.isHidden = available
        mBtnSend.tintColor = UIColor.init(argb: available ? 0xFF1273EB : 0xFFC1C1C1)
    }
    
    func updateChatBox(bottom constant: CGFloat) {
        mChatBoxBottom.constant = constant
    }
    
    func lockAtBottom(offset y: CGFloat) {
        mChatList.contentOffset.y = mChatList.contentSize.height - mChatList.frame.height - y
    }
    
    func animationChatBox(duration: TimeInterval) {
        let offset = mChatList.contentSize.height - mChatList.contentOffset.y - mChatList.frame.height
        UIView.animate(withDuration: duration, animations: { 
            self.view.layoutIfNeeded()
            self.lockAtBottom(offset: offset)
        })
    }
    
    func clearTextBox() {
        mTextChat.text = ""
        updateChatBox(text: "")
    }
    
    @objc func scrollToBottom() {
        let y = mChatList.contentSize.height - mChatList.bounds.height
        mChatList.scrollRectToVisible(CGRect.init(origin: CGPoint(x: 0, y: y), 
                                                  size: mChatList.bounds.size), animated: true)
    }
    
    func showAlert(msg: String) {
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

