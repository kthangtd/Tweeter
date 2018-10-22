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
        
        perform(#selector(openChat), with: nil, afterDelay: 1)
    }
    
    @objc func openChat() {
        self.present(mChatModule.view, animated: false, completion: nil)
    }
    
}
