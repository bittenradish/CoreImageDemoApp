//
//  LumosViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 24.11.23.
//

import UIKit

class LumosViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var toogle: Bool = false
    private var outputImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = setOriginalImage()
        generateOutputImage()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setOriginalImage() -> UIImage? {
        UIImage(named: "lumos.jpg")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        toogle.toggle()
        if(toogle){
            imageView.image = outputImage
        }else{
            imageView.image = setOriginalImage()
        }
    }
    
    private func generateOutputImage(){
        if let original = imageView.image{
            let original = CIImage(image: original)!
            
            let center = CIVector(x: original.extent.width/2, y: original.extent.height/2)
            let radius = min(original.extent.width, original.extent.height)/8
            
            let filter = CIFilter.sunbeamsGenerator()
            filter.setValue(center, forKey: kCIInputCenterKey)
            filter.setValue(radius, forKey: "inputSunRadius")
            
            if let output = filter.outputImage?.cropped(to: original.extent){
                let result = composition(inputImage: output, backgroundImage: original)
                outputImage = UIImage(ciImage: result)
            }
        }
    }
    
    private func composition(inputImage:CIImage, backgroundImage: CIImage) -> CIImage{
        let filter = CIFilter.additionCompositing()
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage ?? inputImage
    }
}
