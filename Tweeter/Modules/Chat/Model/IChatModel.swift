//
//  IChatModel.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/24/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation

protocol IChatModel {
    
    func getCount() -> Int
    func getItem(at: Int) -> ChatMessage?
    func addItem(msg: ChatMessage) -> Void
    func removeItem(at: Int) -> ChatMessage?
}
