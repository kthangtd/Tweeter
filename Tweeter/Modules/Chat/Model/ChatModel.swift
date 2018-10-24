//
//  ChatModel.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/24/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation

class ChatModel: IChatModel {
    
    var mStore: [ChatMessage] = []
    
    func getCount() -> Int {
        return mStore.count
    }
    
    func getItem(at: Int) -> ChatMessage? {
        return (at < getCount() && at >= 0) ? mStore[at] : nil
    }
    
    func addItem(msg: ChatMessage) {
        mStore.append(msg)
    }
    
    func removeItem(at: Int) -> ChatMessage? {
        guard at >= 0 && at < getCount() else {
            return nil
        }
        return mStore.remove(at: at)
    }
}
