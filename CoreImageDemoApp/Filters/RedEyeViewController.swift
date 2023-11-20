//
//  RedEyeViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 20.11.23.
//

import UIKit
import CoreImage

class RedEyeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var inputImage = imageView.image
        
        if var ciImage = CIImage(image: inputImage!){
            let filterList = ciImage.autoAdjustmentFilters()
            filterList.forEach{ filter in
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                if let filteredImage = filter.outputImage{
                    print("applied filter: \(filter.name)")
                    ciImage = filteredImage
                }
            }
            imageView.image = UIImage(ciImage: ciImage)
        }
    }
    
    
}
