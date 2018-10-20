//
//  ChatModule.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation

class ChatModule {
    
    var view: ChatViewController!
    var presenter: IChatPresenter! 
    
    init() {
        view = ChatViewController.create() as? ChatViewController
        presenter = ChatPresenter(root: view)
        view.presenter = presenter
    }
    
}
