//
//  ChatViewController.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var mTextBounds: UILabel!
    @IBOutlet weak var mTextPlaceHolder: UILabel!
    @IBOutlet weak var mTextChat: UITextView!
    @IBOutlet weak var mChatBoxBottom: NSLayoutConstraint!
    @IBOutlet weak var mBtnSend: UIButton!
    @IBOutlet weak var mChatList: UICollectionView!
    
    private var mPresenter: ChatPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = ChatPresenter(root: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mPresenter.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mPresenter.unregisterNotification()
    }
    
    func notifyDataChanged() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        mChatList.reloadData()
        perform(#selector(scrollToBottom), with: nil, afterDelay: 0.2)
    }
    
    func renderChatBox(text: String) {
        mTextBounds.text = text
        let available = text.count > 0
        mBtnSend.isEnabled = available
        mTextPlaceHolder.isHidden = available
        mBtnSend.tintColor = UIColor.init(argb: available ? 0xFF1273EB : 0xFFC1C1C1)
    }
    
    func clearTextBox() {
        mTextChat.text = ""
        renderChatBox(text: "")
    }
    
    @objc func scrollToBottom() {
        mChatList.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: 0, y: mChatList.contentSize.height-mChatList.bounds.height), 
                                                  size: mChatList.bounds.size), animated: true)
    }
    
    func lockAtBottom(offsetY: CGFloat) {
        mChatList.contentOffset.y = mChatList.contentSize.height - mChatList.frame.height - offsetY
    }
    
    private func closeKeyboard() {
        if mTextChat.isFirstResponder {
            mTextChat.resignFirstResponder()
        }
    }
    
    // MARK: Users Actions
    
    @IBAction private func btnSend_Click(_ sender: Any) {
        mPresenter.send(msg: mTextChat.text)
        clearTextBox()
    }
    
    @IBAction private func chatList_Tap(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }
}

