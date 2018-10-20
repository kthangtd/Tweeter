//
//  UIViewController.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func create() -> UIViewController! {
        return create(storyboard: name())
    }
    
    static func create(storyboard name:String) -> UIViewController! {
        return UIStoryboard.init(name: name, bundle: Bundle.main).instantiateInitialViewController()!
    }
    
    static func create(storyboard name:String, bundle inBundle:Bundle) -> UIViewController! {
        return UIStoryboard.init(name: name, bundle: inBundle).instantiateInitialViewController()!
    }
}
