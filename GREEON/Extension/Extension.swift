//
//  Extension.swift
//  GREEON
//
//  Created by Yushi Kang on 2/12/24.
//

import Foundation
import UIKit
import SwiftUI

extension CATransition {
  func segueFromBottom() -> CATransition {
    duration = 0.375 //set the duration to whatever you'd like.
    timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    type = .moveIn
    subtype = .fromTop
    return self
  }
  
  func segueFromTop() -> CATransition {
    duration = 0.375 //set the duration to whatever you'd like.
    timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    type = .moveIn
    subtype = .fromBottom
    return self
  }
  
  func segueFromLeft() -> CATransition {
    duration = 0.1 //set the duration to whatever you'd like.
    timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    type = .moveIn
    subtype = .fromLeft
    return self
  }
  
  func popFromRight() -> CATransition {
    duration = 0.1 //set the duration to whatever you'd like.
    timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    type = .reveal
    subtype = .fromRight
    return self
  }
  
  func popFromLeft() -> CATransition {
    duration = 0.1 //set the duration to whatever you'd like.
    timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    type = .reveal
    subtype = .fromLeft
    return self
  }
}

extension UIColor {
  convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(hex & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
