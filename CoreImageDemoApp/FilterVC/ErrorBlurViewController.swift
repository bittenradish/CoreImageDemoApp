//
//  BlurViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit
import CoreImage

class ErrorBlurViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let image = self?.getOriginalImage() else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    private func getOriginalImage() -> UIImage? {
        UIImage(named: "landscape.jpg")
    }
    
    
    @IBAction func onSliderChanged(_ sender: Any) {
        let sliderValue = slider.value
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let originalImage = self?.getOriginalImage() else {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlet(message: "There is no image in imageView")
                }
                return
            }
            
            let cgFloat = CGFloat(sliderValue)
            
            if let image = self?.applyFilter(filterValue: cgFloat, image: originalImage){
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
    }
    
    
    private func applyFilter(filterValue: CGFloat, image: UIImage) -> UIImage? {
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
extension UIImage {
    func resized(to newSize: CGSize, contentMode: UIView.ContentMode) -> UIImage? {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)

        var newSize = newSize
        if contentMode == .scaleAspectFit {
            newSize.width = size.width * ratio
            newSize.height = size.height * ratio
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
