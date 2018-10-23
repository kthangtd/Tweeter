//
//  MainViewController.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/21/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var mChatModule: ChatModule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mChatModule = ChatModule()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openChat()
    }
    
    private func openChat() {
        self.present(mChatModule.view, animated: false, completion: nil)
    }
    
}
