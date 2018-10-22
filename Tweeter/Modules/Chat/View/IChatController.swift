//
//  IChatController.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

protocol IChatController: NSObjectProtocol {
    
    var presenter: IChatPresenter? { set get }
    
    func notifyDataChanged()
    func updateChatBox(text str: String)
    func updateChatBox(bottom constant: CGFloat)
    func lockAtBottom(offset y: CGFloat)
    func animationChatBox(duration: TimeInterval)
    func clearTextBox()
    func scrollToBottom()
    func showAlert(msg: String)
}
