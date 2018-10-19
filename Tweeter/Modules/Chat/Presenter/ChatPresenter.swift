//
//  ChatPresenter.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

class ChatPresenter: NSObject {
    
    // MARK: Private Variable
    private weak var mRoot: ChatViewController!
    private let mSplitter: Splitter = Splitter()
    private var mMessages: [ChatMessage] = []
    
    private let mMessageQueue: DispatchQueue = DispatchQueue.init(label: "vn.com.kthangtd.ios.Tweeter.messageQueue")
    private let mSplitQueue: DispatchQueue = DispatchQueue.init(label: "vn.com.kthangtd.ios.Tweeter.splitQueue")
    
    init(root: ChatViewController) {
        super.init()
        mRoot = root
        setup()
    }
    
    deinit {
    }
    
    // MARK: Public Method
    
    @objc func registerNotification() {
        unregisterNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), 
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), 
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), 
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func unregisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private Method
    
    private func setup() {
        mRoot.mTextChat.delegate = self
        mRoot.mChatList.dataSource = self
        mRoot.mChatList.delegate = self
        
        runDemo()
    }

    private func runDemo() {
        for i:Int in 0...100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ 
                self.send(msg: "message \(i)")
            }
        }
    }
}

// MARK: Notification Event 
extension ChatPresenter {
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
                let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        mRoot.mChatBoxBottom.constant = keyboardSize.height
        animationChatBox(duration: duration)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let info = notification.userInfo,
            let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                return
        }
        mRoot.mChatBoxBottom.constant = 0
        animationChatBox(duration: duration)
    }
    
    @objc private func appDidEnterBackground() {
        unregisterNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(registerNotification), 
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func animationChatBox(duration: TimeInterval) {
        let offsetY = mRoot.mChatList.contentSize.height - mRoot.mChatList.contentOffset.y - mRoot.mChatList.frame.height
        UIView.animate(withDuration: duration, animations: { 
            self.mRoot.view.layoutIfNeeded()
            self.mRoot.lockAtBottom(offsetY: offsetY)
        })
    }
}

// MARK: Simulate Send Action
extension ChatPresenter {
    
    // MARK: Public Method
    func send(msg: String) {
        mSplitQueue.async {
            guard let result = self.mSplitter.splitMessage(msg: msg) else {
                fatalError("error")
            }
            self.performMessageQueue(listMsg: result)
        }
    }
    
    // MARK: Private Method
    private func performMessageQueue(listMsg: [String]) {
        mMessageQueue.async {
            for subMsg in listMsg {
                self.processMessage(msg: subMsg)
            }
            self.performNotifyDataChanged()
        }
    }
    
    private func processMessage(msg: String) {
        let chatMsg = ChatMessage(msg: msg)
        mMessages.append(chatMsg)
        // TODO: send msg to network
    }
    
    private func performNotifyDataChanged() {
        DispatchQueue.main.async {
            self.mRoot.notifyDataChanged()
        }
    }
}

// MARK: UITextViewDelegate
extension ChatPresenter: UITextViewDelegate  {
    
    func textViewDidChange(_ textView: UITextView) {
        mRoot.renderChatBox(text: textView.text)
    }
}

// MARK: UICollectionViewDataSource
extension ChatPresenter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let msg = mMessages[indexPath.item]
        cell.setData(msg: msg)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ChatPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let msg = mMessages[indexPath.item]
        return msg.calculate(width: collectionView.frame.width)
    }
}
