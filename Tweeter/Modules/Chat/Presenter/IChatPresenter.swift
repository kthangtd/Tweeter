//
//  IChatPresenter.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

protocol IChatPresenter: UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var model: IChatModel? { set get }
    
    init(view: IChatController)
    
    func registerNotification()
    func unregisterNotification()  
    func send(msg: String)
}
