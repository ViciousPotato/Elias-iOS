//
//  BitModel.swift
//  Elias
//
//  Created by zhou on 11/2/15.
//  Copyright (c) 2015 zhou. All rights reserved.
//

import Foundation

class Bit {
    let content: String

    init(content: String) {
        self.content = content
    }
    
    class func fromJSONDic(dic: NSDictionary) -> Bit {
        return Bit(content: dic["content"] as String)
    }
}