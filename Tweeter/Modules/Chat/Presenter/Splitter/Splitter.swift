//
//  Splitter.swift
//  Tweeter
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import Foundation

class Splitter {
    
    private let MAX_CHAR_IN_MSG: Int = 50
    private let MAX_CHAR_IN_SUB: Int = 46
    
    func splitMessage(msg: String) -> [String]? {
        if msg.count <= MAX_CHAR_IN_MSG {
            return [msg]
        }
        
        
        var rs: [String] = []
        var words: [Substring] = msg.split(separator: " ", omittingEmptySubsequences: false)
        let count = recognizeCount(str: msg)  
        
        var subMsg = ""
        for i in 1...(count + 1) {
            subMsg = "\(i)/\(count)"
            var isBreak = false
            while !isBreak && words.count > 0 {
                var word = words[0]
                if word.count >= MAX_CHAR_IN_MSG {
                    return nil
                }
                if word == "" {
                    word = " "
                }
                if subMsg.count + word.count + 1 <= MAX_CHAR_IN_MSG {
                    subMsg += " " + word
                    words.removeFirst()
                } else {
                    rs.append(subMsg)
                    subMsg = ""
                    isBreak = true
                }
            }
        }
        if subMsg.count > 0, let _ = subMsg.firstIndex(of: " ") {
            rs.append(subMsg)
        }
        
        if rs.count > count {
            for i in 1...rs.count {
                let pos = i - 1
                var str = rs[pos]
                str = str.replacingCharacters(in: ..<str.firstIndex(of: " ")!, with: "\(i)/\(rs.count)")
                rs[pos] = str
            }
        }

        return rs
    }
    
    private func recognizeCount(str: String) -> Int {
        var count = str.count / MAX_CHAR_IN_SUB
        if str.count % MAX_CHAR_IN_SUB > 0 {
            count += 1
        }
        return count
    }
    
    
    
}
