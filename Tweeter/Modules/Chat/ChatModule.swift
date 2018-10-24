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
    var model: IChatModel!
    
    init() {
        view = ChatViewController.create() as? ChatViewController
        presenter = ChatPresenter(view: view)
        model = ChatModel()
        
        presenter.model = model
        view.presenter = presenter
    }
    
}
