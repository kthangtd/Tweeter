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
    private let MAX_CHAR_IN_SUB: Int = 47   // MAX_CHAR_IN_MSG - 3 (x/x)
    
    func splitMessage(msg: String) -> [String]? {
        guard msg.count > MAX_CHAR_IN_MSG else {
            return [msg]
        }
        
        var rs: [String] = []
        var words: [Substring] = msg.split(separator: " ", omittingEmptySubsequences: false)
        let count = getCount(msg)
        
        var subMsg = ""
        for i in 1...(count + 1)  {
            guard words.count > 0 else {
                break
            }
            
            subMsg = "\(i)/\(count)"
            var isBreak = false
            while !isBreak && words.count > 0 {
                var word = words[0]
                
                guard word.count < MAX_CHAR_IN_MSG else {
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
    
    private func getCount(_ msg: String) -> Int {
        var count = calcTotal(len: msg.count, max: MAX_CHAR_IN_SUB)
        let lenTotal = String(count).count 
        var total = msg.count
        var i = 1
        while count > 0 {
            let p9 = 9 * pow(a: 10, b: i-1)
            total += (i + 1 + lenTotal) * min(count, p9)
            count -= p9
            i += 1
        }
        count = calcTotal(len: total, max: MAX_CHAR_IN_MSG)
        return count
    }
    
    private func calcTotal(len: Int, max: Int) -> Int {
        var total = len / max
        if len % max > 0 {
            total += 1
        }
        return total
    }
    
    private func pow(a: Int, b: Int) -> Int {
        return Int(powf(Float(a), Float(b)))
    }
    
}
