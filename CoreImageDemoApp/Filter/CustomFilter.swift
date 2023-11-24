//
//  CustomFilter.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 24.11.23.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

let kCIInputBloomIntencity: String = "bloomIntensity"
let kCIInputEdgeIntencity: String = "edgeIntensity"

class CustomFilter : CIFilter {
    
    private var inputImage : CIImage?
    private var ciEdgeIntesity: NSNumber = 10
    private var saturation: NSNumber = 1.75
    private var radius: NSNumber = 2.5
    private var bloomIntensity: NSNumber = 1.25
    private var inputEv: NSNumber = -1.5
    
    private let listOfAttributes: [String: Any] = [
        kCIInputImageKey: CIImage.self,
        kCIInputEdgeIntencity: NSNumber.self,
        kCIInputSaturationKey: NSNumber.self,
        kCIInputRadiusKey: NSNumber.self,
        kCIInputBloomIntencity: NSNumber.self,
        kCIInputEVKey: NSNumber.self
    ]
    
    override func setDefaults() {
        ciEdgeIntesity = 10
        saturation = 1.75
        radius = 2.5
        bloomIntensity = 1.25
        inputEv = -1.5
    }
    
    override var attributes: [String : Any] {
        listOfAttributes
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if listOfAttributes.keys.contains(key) {
            switch key {
            case kCIInputImageKey:
                inputImage = value as! CIImage
                
            case kCIInputEdgeIntencity:
                ciEdgeIntesity = value as! NSNumber
                
            case kCIInputSaturationKey:
                saturation = value as! NSNumber
                
            case kCIInputRadiusKey:
                radius = value as! NSNumber
                
            case kCIInputBloomIntencity:
                bloomIntensity = value as! NSNumber
                
            case kCIInputEVKey:
                inputEv = value as! NSNumber
                
            default:
                print()
            }
        } else {
            //Do nothing it is better to throw error
        }
    }
    
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        let edgeOutput = edgesImage(inputImage: inputImage)
        
        let colorConrolsOutput = colorControls(inputImage: edgeOutput)
        let bloomOutput = bloom(inputImage: colorConrolsOutput, rect: inputImage.extent)
        
        let noirOurput = noirFilter(inputImage: inputImage)
        let exposureOutPut = exposureAdjust(inputImage: noirOurput)
        
        
        let finalComposite = composition(inputImage: bloomOutput, backgroundImage: exposureOutPut)
        return finalComposite
    }
    
    private func edgesImage(inputImage: CIImage) -> CIImage {
        inputImage.applyingFilter("CIEdges", parameters: [kCIInputIntensityKey: ciEdgeIntesity])
    }
    
    private func colorControls(inputImage: CIImage) -> CIImage {
        let filter = CIFilter.colorControls()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(saturation, forKey: kCIInputSaturationKey)
        
        return filter.outputImage ?? inputImage
    }
    
    private func bloom(inputImage: CIImage, rect: CGRect) -> CIImage {
        let filter = CIFilter.bloom()
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        filter.setValue(bloomIntensity, forKey: kCIInputIntensityKey)
        
        return filter.outputImage?.cropped(to: rect) ?? inputImage
    }
    
    private func noirFilter(inputImage: CIImage) -> CIImage {
        inputImage.applyingFilter("CIPhotoEffectNoir")
    }
    
    private func exposureAdjust(inputImage: CIImage) -> CIImage {
        let filter = CIFilter.exposureAdjust()
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputEv, forKey: kCIInputEVKey)
        
        return filter.outputImage ?? inputImage
    }
    
    private func composition(inputImage:CIImage, backgroundImage: CIImage) -> CIImage{
        let filter = CIFilter.additionCompositing()
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage ?? inputImage
    }
    
    private func test() -> CIImage? {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let edgesImage = inputImage
            .applyingFilter(
                "CIEdges",
                parameters: [
                    kCIInputIntensityKey: 10])
        
        let glowingImage = CIFilter(
            name: "CIColorControls",
            parameters: [
                kCIInputImageKey: edgesImage,
                kCIInputSaturationKey: 1.75])?
            .outputImage?
            .applyingFilter(
                "CIBloom",
                parameters: [
                    kCIInputRadiusKey: 2.5,
                    kCIInputIntensityKey: 1.25])
            .cropped(to: inputImage.extent)
        
        let darkImage = inputImage
            .applyingFilter(
                "CIPhotoEffectNoir")
            .applyingFilter(
                "CIExposureAdjust",
                parameters: [
                    "inputEV": -1.5])
        
        let finalComposite = glowingImage!
            .applyingFilter(
                "CIAdditionCompositing",
                parameters: [
                    kCIInputBackgroundImageKey:
                        darkImage])
        
        return finalComposite
    }
}
