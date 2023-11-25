//
//  BlurViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 21.11.23.
//

import UIKit
import CoreImage

class BlurViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var radiusLabel: UILabel!
    
    let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "testImage.jpg")
        radiusLabel.text = getRadiusString(radius: 0.0)
    }
    
    private func getRadiusString(radius: Float) -> String {
        "Radius: \(radius.rounded())"
    }
    
    @IBAction func onSliderChanged(_ sender: Any) {
        let sliderVal = slider.value
        let value = CGFloat(sliderVal)
        radiusLabel.text = getRadiusString(radius: sliderVal)
        imageView.image = applyFilter(filterValue: value)
    }
    
    func applyFilter(filterValue: CGFloat) -> UIImage? {
        // Get the original image
        guard let originalImage = UIImage(named: "testImage.jpg") else {
            return nil
        }
        
        let originalCIImage = CIImage(image: originalImage)!
        
        guard let filter = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        filter.setValue(filterValue, forKey: kCIInputRadiusKey)
        
        let filteredCIImage = filter.outputImage!
        
        guard let cgImage = ciContext.createCGImage(filteredCIImage, from: filteredCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}
