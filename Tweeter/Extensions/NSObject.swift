//
//  NSObject.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/20/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation

extension NSObject {
    
    static func namespace() -> String {
        return (Bundle.main.infoDictionary!["CFBundleExecutable"] as! String).replacingOccurrences(of: " ", with: "_")
    }
    
    static func name() -> String {
        let name = NSStringFromClass(self.classForCoder())
        let namespace = self.namespace()
        return String(name.suffix(name.count-namespace.count-1))
    }
}
