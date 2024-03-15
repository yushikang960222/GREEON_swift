//
//  customTabbar.swift
//  Pods
//
//  Created by Yushi Kang on 2/21/24.
//

import UIKit
import SwiftUI

@IBDesignable
class CustomTabBar: UITabBar {
  private var shapeLayer: CALayer?
  private func addShape() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = createPath()
    shapeLayer.strokeColor = UIColor(hex: 0xd1d1d1).cgColor
    shapeLayer.fillColor = UIColor.white.cgColor
    shapeLayer.lineWidth = 0.5
    
    // 탭바의 그림자 추가
    shapeLayer.shadowOffset = CGSize(width:0, height:0)
    shapeLayer.shadowRadius = 5
    shapeLayer.shadowColor = UIColor(hex: 0x000000).cgColor
    shapeLayer.shadowOpacity = 0.1
    
    if let oldShapeLayer = self.shapeLayer {
      self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
    } else {
      self.layer.insertSublayer(shapeLayer, at: 0)
    }
    self.shapeLayer = shapeLayer
  }
  override func draw(_ rect: CGRect) {
    self.addShape()
  }
  func createPath() -> CGPath {
    let height: CGFloat = 45.0
    let path = UIBezierPath()
    let centerWidth = self.frame.width / 2
    path.move(to: CGPoint(x: 0, y: 0)) // 왼쪽에서부터 시작
    path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
    
    // 왼쪽 굴곡 지는 부분 설정
    path.addCurve(to: CGPoint(x: centerWidth, y: height),
                  controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
    
    // 오른쪽 굴곡 지는 부분 설정
    path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                  controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
    
    path.addLine(to: CGPoint(x: self.frame.width, y: 0))
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
    path.addLine(to: CGPoint(x: 0, y: self.frame.height))
    path.close()
    
    return path.cgPath
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
    for member in subviews.reversed() {
      let subPoint = member.convert(point, from: self)
      guard let result = member.hitTest(subPoint, with: event) else { continue }
      return result
    }
    return nil
  }
}

extension CustomTabBar: UITabBarControllerDelegate {
  override func awakeFromNib() {
    super.awakeFromNib()
    if let tabBarController = self.delegate as? UITabBarController {
      tabBarController.delegate = self
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
      UIImpactFeedbackGenerator(style: .medium).impactOccurred() // 햅틱 피드백
    }
  }
}

