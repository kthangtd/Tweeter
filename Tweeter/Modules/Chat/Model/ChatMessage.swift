//
//  ChatMessage.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

class ChatMessage {
    var msg: String?
    private var size: CGSize = CGSize.zero
    
    init(msg: String) {
        self.msg = msg
    }
    
    func calculate(width: CGFloat) -> CGSize {
        if size == CGSize.zero {
            let w = width - 20 - 40
            let constraintRect = CGSize(width: w, height: .greatestFiniteMagnitude)
            if let boundingBox = msg?.boundingRect(with: constraintRect, 
                                                options: [.usesLineFragmentOrigin, .usesFontLeading], 
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], 
                                                context: nil) {
                size = CGSize.init(width: width, height: max(boundingBox.height + 20, 38))
            }
        }
        return size
    }
}
