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

    weak var mView: IChatController?
    let mSplitter: Splitter = Splitter()
    var model: IChatModel?
    
    let mMessageQueue: DispatchQueue = DispatchQueue.init(label: "vn.com.kthangtd.ios.Tweeter.messageQueue")
    let mSplitQueue: DispatchQueue = DispatchQueue.init(label: "vn.com.kthangtd.ios.Tweeter.splitQueue")
    
    required init(view: IChatController) {
        super.init()
        mView = view
    }

    deinit {
        model = nil
    }
}

extension ChatPresenter: IChatPresenter {
    
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
}

// MARK: Notification Event 
extension ChatPresenter {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let view = mView else {
            return
        }
        view.updateChatBox(bottom: keyboardSize.height)
        view.animationChatBox(duration: duration)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let info = notification.userInfo,
            let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let view = mView else {
                return
        }
        view.updateChatBox(bottom: 0)
        view.animationChatBox(duration: duration)
    }
    
    @objc func appDidEnterBackground() {
        unregisterNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(registerNotification), 
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

// MARK: Send Action
extension ChatPresenter {
    
    func send(msg: String) {
        mSplitQueue.async {
            guard let result = self.mSplitter.splitMessage(msg: msg) else {
                self.showAlert(msg: "Split Error: has a word more than 50 chars.")
                return
            }
            self.performMessageQueue(listMsg: result)
        }
    }
    
    func showAlert(msg: String) {
        guard let view = mView else {
            return
        }
        DispatchQueue.main.async {
            view.showAlert(msg: msg)
        }
    }
    
    func performMessageQueue(listMsg: [String]) {
        mMessageQueue.async {
            for subMsg in listMsg {
                self.processMessage(msg: subMsg)
            }
            self.performNotifyDataChanged()
        }
    }
    
    func processMessage(msg: String) {
        let chatMsg = ChatMessage(msg: msg)
        model?.addItem(msg: chatMsg)
        // TODO: send msg to network
    }
    
    func performNotifyDataChanged() {
        guard let view = mView else {
            return
        }
        DispatchQueue.main.async {
            view.notifyDataChanged()
        }
    }
}

// MARK: UITextViewDelegate
extension ChatPresenter  {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let view = mView else {
            return
        }
        view.updateChatBox(text: textView.text)
    }
}

// MARK: UICollectionViewDataSource
extension ChatPresenter {
    
    func collectionView(_ collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
        return model?.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.name(), for: indexPath) as! ChatMessageCell
        let msg = model?.getItem(at: indexPath.item)
        cell.setData(msg: msg!)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ChatPresenter {
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let msg = model?.getItem(at: indexPath.item)
        return msg!.calculate(width: collectionView.frame.width)
    }
}
