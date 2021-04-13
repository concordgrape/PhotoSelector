//
//  PhotoLibraryCell.swift
//  FilterTest
//
//  Created by Sky Roth on 2021-04-05.
//  Last updated by Sky Roth on 2021-04-06.
//
//  This class will act as each custom cell in the photo library collection view

import UIKit

class PhotoLibraryCell: UICollectionViewCell {
    
    
    // MARK: - VIEWS
    let overlayView = UIView()
    
    
    
    // MARK: - CELL PROPERTIES
    
    
    
    // Step 1. Check if the cell is selected or not
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // Step 2. Check if the cell has already been clicked -> If it has, remove the selected properties
                if layer.borderWidth == Constants.kBORDERWIDTH { layer.borderWidth = 0; layer.borderColor = UIColor.clear.cgColor; overlayView.removeFromSuperview(); return }
                
                // Step 2.1 If the cell wasn't selected, add the selected properties
                layer.borderWidth = Constants.kBORDERWIDTH
                overlayView.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 0.5)
                overlayView.frame = self.bounds
                overlayView.alpha = 0
                
                // Step 2.2 Add the overlay view to the main cell
                self.addSubview(overlayView) // add the overlay to the UIImage
                
                // Step 3. Show the view with an animation when the user clicks the cell
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.overlayView.alpha = 1.0
                })
               
            } else {
                // Step 4. Remove the selected properties once the user clicks another cell
                layer.borderWidth = 0
                
                // remove the overlay with animation as the cell is no longer selected
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                    //self.overlayView.alpha = 0
                    self.overlayView.removeFromSuperview()
                })
            }
        }
    }
}
