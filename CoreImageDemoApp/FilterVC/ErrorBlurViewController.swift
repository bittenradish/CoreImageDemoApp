//
//  BlurViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit
import CoreImage

class ErrorBlurViewController: UIViewController {
    
    @MainActor
    @IBOutlet weak var imageView: UIImageView!
    
    @MainActor
    @IBOutlet weak var slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSliderChanged(_ sender: Any) {
        guard let originalImage = imageView.image else {
            showAlet(message: "There is no image in imageView")
            return
        }
        
        let cgFloat = CGFloat(slider.value)
        Task(priority: .background) {
            if let image = await self.applyFilter(filterValue: cgFloat, image: originalImage){
                self.updateImage(image: image)
            }
        }
    }
    
    @MainActor
    private func updateImage(image: UIImage){
        imageView.image = image
    }
    
    
    private func applyFilter(filterValue: CGFloat, image: UIImage) async -> UIImage? {
        let context = CIContext(options: nil)
        
        guard let ciImage = CIImage(image: image) else {
            //            showAlet(message: "Can't parse to CIImage")
            return nil
        }
        
        guard let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur") else{
            //            showAlet(message: "No filter found")
            return nil
        }
        
        gaussianBlurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(filterValue, forKey: kCIInputRadiusKey)
        
        guard let outputCIImage = gaussianBlurFilter.outputImage else{
            //            showAlet(message: "Filter didn't not applied")
            return nil
        }
        
        
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else{
            //            showAlet(message: "Can not parse CGImage")
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    
    private func showAlet(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
