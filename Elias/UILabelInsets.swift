//
//  UILabelInsets.swift
//  Elias
//
//  Created by zhou on 6/5/15.
//  Copyright (c) 2015 zhou. All rights reserved.
//

import Foundation

@objc(UILabelInsets) class UILabelInsets : UILabel {
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
}
