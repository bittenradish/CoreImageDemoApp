//
//  SepiaViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 21.11.23.
//

import UIKit

class SepiaViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var intensityLable: UILabel!
    
    
    let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "testImage.jpg")
        intensityLable.text = getIntencityString(radius: 0.0)
    }
    
    private func getIntencityString(radius: Float) -> String {
        String(format: "Intencity: %.2f", radius)
    }
    
    @IBAction func onSliderChanged(_ sender: Any) {
        let sliderVal = slider.value
        intensityLable.text = getIntencityString(radius: sliderVal)
        imageView.image = applyFilter(filterValue: sliderVal)
    }
    
    func applyFilter(filterValue: Float) -> UIImage? {
        // Get the original image
        guard let originalImage = UIImage(named: "testImage.jpg") else {
            return nil
        }
        
        let originalCIImage = CIImage(image: originalImage)!
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        filter.setValue(filterValue, forKey: kCIInputIntensityKey)
        
        let filteredCIImage = filter.outputImage!
        
        guard let cgImage = ciContext.createCGImage(filteredCIImage, from: filteredCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}
