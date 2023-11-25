//
//  InvertViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 21.11.23.
//

import UIKit

class InvertViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var toggle: UISwitch!
    
    let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "testImage.jpg")
    }
    
    @IBAction func onToggleSwitched(_ sender: Any) {
        if(toggle.isOn){
            imageView.image = applyFilter()
        }else{
            imageView.image = setOriginalImage()
        }
    }
    
    private func setOriginalImage() -> UIImage? {
        UIImage(named: "testImage.jpg")
    }
    
    private func applyFilter() -> UIImage? {
        // Get the original image
        guard let originalImage = UIImage(named: "testImage.jpg") else {
            return nil
        }
        
        let originalCIImage = CIImage(image: originalImage)!
        
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        let filteredCIImage = filter.outputImage!
        
        guard let cgImage = ciContext.createCGImage(filteredCIImage, from: filteredCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}
