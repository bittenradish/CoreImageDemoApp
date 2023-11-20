//
//  CGImagePropertyOrientationExtension.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 20.11.23.
//

import UIKit
import ImageIO
  
extension CGImagePropertyOrientation {

    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError("unknown orientation passed ")
        }
    }
}
