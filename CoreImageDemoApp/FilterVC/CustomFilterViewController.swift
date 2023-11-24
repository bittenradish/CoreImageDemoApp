//
//  FilterViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit

class CustomFilterViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var edgeIntensitySlider: UISlider!
    
    @IBOutlet weak var saturationSlider: UISlider!
    
    @IBOutlet weak var radiusSlider: UISlider!
    
    @IBOutlet weak var bloomInensitySlider: UISlider!
    
    @IBOutlet weak var expositionSlider: UISlider!
    
    private let ciContext = CIContext()
    private let filter = CustomFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = setOriginalImage()
        
    }
    
    private func setOriginalImage() -> UIImage? {
        UIImage(named: "redEye.jpg")
    }
    
    @IBAction func resetImage(_ sender: Any) {
        imageView.image = setOriginalImage()
    }
    @IBAction func applyDefaultFilter(_ sender: Any) {
        edgeIntensitySlider.value = 10
        saturationSlider.value = 1.75
        radiusSlider.value = 2.5
        bloomInensitySlider.value = 1.25
        expositionSlider.value = -1.5
        filter.setDefaults()
        imageView.image = applyFilter()
    }
    
    
    @IBAction func slidersChanged(_ sender: Any) {
        filter.setValue(edgeIntensitySlider.value as NSNumber, forKey: kCIInputEdgeIntencity)
        filter.setValue(saturationSlider.value as NSNumber, forKey: kCIInputSaturationKey)
        filter.setValue(radiusSlider.value as NSNumber, forKey: kCIInputRadiusKey)
        filter.setValue(bloomInensitySlider.value as NSNumber, forKey: kCIInputBloomIntencity)
        filter.setValue(expositionSlider.value as NSNumber, forKey: kCIInputEVKey)
        
        if let output = applyFilter() {
            imageView.image = output
        }
    }
    
    private func applyFilter() -> UIImage? {
        // Get the original image
        guard let originalImage = setOriginalImage() else {
            return nil
        }
        
        let originalCIImage = CIImage(image: originalImage)!
        
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        let filteredCIImage = filter.outputImage!
        
        guard let cgImage = ciContext.createCGImage(filteredCIImage, from: filteredCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
