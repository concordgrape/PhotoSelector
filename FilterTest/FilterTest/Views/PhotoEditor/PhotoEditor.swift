//
//  PhotoEditor.swift
//  FilterTest
//
//  Created by Sky Roth on 2021-04-05.
//

import UIKit

class PhotoEditor: UIViewController {

    @IBOutlet var imgView: UIImageView!
    
    var img: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.image = img
    }
}
