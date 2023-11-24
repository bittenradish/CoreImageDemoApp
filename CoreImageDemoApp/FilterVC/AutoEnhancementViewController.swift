//
//  AutoEnhancementViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 24.11.23.
//

import UIKit

class AutoEnhancementViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var toggle: UISwitch!
    
    private let ciContext = CIContext(options: nil)
    
    private var outputImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAutoEnhancement()
    }
    
    private func setOriginalImage() -> UIImage? {
        UIImage(named: "oldPhoto.jpg")
    }
    
    @IBAction func onToggleChanged(_ sender: Any) {
        if(toggle.isOn){
            imageView.image = outputImage
        }else{
            imageView.image = setOriginalImage()
        }
    }
    
    private func applyAutoEnhancement(){
        let inputImage = setOriginalImage()
        
        if var ciImage = CIImage(image: inputImage!){
            
            let options = [CIImageAutoAdjustmentOption.redEye: false]
            
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
            outputImage = UIImage(cgImage: cgImage)
        }
        
    }
}
