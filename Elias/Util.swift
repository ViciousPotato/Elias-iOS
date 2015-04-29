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
  static var baseUrl = "http://127.0.0.1:3000/"
  #else
  static var baseUrl = "http://viciouspotato.me/"
  #endif
  
  static var initLoadUrl = "http://192.168.2.103:3000/bit/since/0"
  static var imageUploadUrl = "http://192.168.2.103:3000/upload"
  static var createBitUrl = "http://192.168.2.103:3000/bit"
  
  static var imageCompressRate =  CGFloat(0.8)
}