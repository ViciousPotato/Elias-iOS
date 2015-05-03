//
//  Util.swift
//  Elias
//
//  Created by zhou on 8/2/15.
//  Copyright (c) 2015 zhou. All rights reserved.
//

import Foundation

struct Util {
  static var now = Int(NSTimeIntervalSince1970)
  
  #if TARGET_IPHONE_SIMULATOR
  static var baseUrl = "http://127.0.0.1:3000"
  #else
  static var baseUrl = "http://viciouspotato.me"
  #endif
  
  static var initLoadUrl = "\(baseUrl)/bit/since/0"
  static var imageUploadUrl = "\(baseUrl)/upload"
  static var createBitUrl = "\(baseUrl)/bit"
  
  static var imageCompressRate =  CGFloat(0.8)
  
  static func UIColorFromHex(rgbValue: UInt32) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
    let blue = CGFloat(rgbValue & 0xFF) / 256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
  }
}