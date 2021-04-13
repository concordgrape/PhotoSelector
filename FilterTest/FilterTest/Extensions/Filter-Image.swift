//
//  Filter-Image.swift
//  FilterTest
//
//  Created by Sky Roth on 2021-03-31.
//

import UIKit

extension UIImage {
    func addFilter(filter : FilterType, intensity: Double = 0) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        if (intensity != 0) { filter?.setValue(intensity, forKey: kCIInputIntensityKey) }
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
    
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
