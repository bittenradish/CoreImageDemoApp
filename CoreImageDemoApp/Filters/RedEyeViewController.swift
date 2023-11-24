//
//  RedEyeViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 20.11.23.
//

import UIKit
import CoreImage
import ImageIO

class RedEyeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    private let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inputImage = imageView.image
        
        if var ciImage = CIImage(image: inputImage!){
            
            let opts: [String : Any] = [CIDetectorAccuracy: CIDetectorAccuracyLow]
            
            let ciDetector = CIDetector(ofType: CIDetectorTypeFace, context: ciContext, options: opts)
            
            let uiImageOrientation = inputImage?.imageOrientation ?? UIImage.Orientation.down
            
            let orientation = CGImagePropertyOrientation(uiImageOrientation).rawValue
            //                        [CIDetectorImageOrientation: CGImagePropertyOrientation.up]
            
            let imageOptions: [String: Any] = [CIDetectorImageOrientation : orientation]
            
            
            let testFeatures = ciDetector?.features(in: ciImage, options: imageOptions)
            
            print(testFeatures ?? "empty")
            
            let options: [CIImageAutoAdjustmentOption : Any] =
            if let features = testFeatures {
                [CIImageAutoAdjustmentOption.features: features, CIImageAutoAdjustmentOption.redEye: true]
            }else{
                [CIImageAutoAdjustmentOption.features: ciDetector ?? CIDetector()]
            }
            
            let filterList = ciImage.autoAdjustmentFilters(options:options)
            filterList.forEach{ filter in
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                if let filteredImage = filter.outputImage{
                    print("applied filter: \(filter.name)")
                    ciImage = filteredImage
                }
            }
            
            guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
                return
            }
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
    
    
}


extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
extension UIImage.Orientation {
    init(_ cgOrientation: UIImage.Orientation) {
        switch cgOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
