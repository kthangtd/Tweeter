//
//  ChatMessageCell.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    @IBOutlet weak var mTextLabel: UILabel!
    
    func setData(msg: ChatMessage) {
        mTextLabel.text = msg.msg
        self.layoutIfNeeded()
    }
}
