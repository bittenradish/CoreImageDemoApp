//
//  FilterViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit

class CustomFilterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var toggle: UISwitch!
    
    let ciContext = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onTooggleChanged(_ sender: Any) {
        if(toggle.isOn){
            imageView.image = applyFilter()
        }else{
            imageView.image = setOriginalImage()
        }
    }
    
    private func setOriginalImage() -> UIImage? {
        UIImage(named: "voldemort.jpg")
    }
    
    private func applyFilter() -> UIImage? {
        // Get the original image
        guard let originalImage = UIImage(named: "voldemort.jpg") else {
            return nil
        }
        
        let originalCIImage = CIImage(image: originalImage)!
        
        let filter = CustomFilter()
        
        print(filter.attributes)
        
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        let filteredCIImage = filter.outputImage!
        
        guard let cgImage = ciContext.createCGImage(filteredCIImage, from: filteredCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
