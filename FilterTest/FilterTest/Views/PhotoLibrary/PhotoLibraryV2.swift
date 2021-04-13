//
//  PhotoLibraryV2.swift
//  FilterTest
//
//  Created by Sky Roth on 2021-04-03.
//  Last Updated by Sky Roth on 2021-04-07.
//
//  This file will grab the latest photos from the users device, if more than 100 photos are found, only 100 will be shown

import UIKit
import Photos
import AssetsLibrary

private let reuseIdentifier = "Cell"

class PhotoLibraryV2: UICollectionViewController {
    
    
    //  MARK: - PROPERTIES
    
    
    // pull to refresh
    let refresher = UIRefreshControl()
    
    
    // options for grabbing photos
    let options = PHFetchOptions()
    var photos: PHFetchResult<PHAsset>!

    // the index of the selected cell
    var selectedIndex: IndexPath = []


    
    
    
    //  MARK: - VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 1. Register the collection view
        self.collectionView!.register(PhotoLibraryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Step 2. Init the delegate and datasource of the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true // this will allow us to call a refresher
    
        // Step 3. Init the refresher
        refresher.addTarget(self, action: #selector(self.refresh), for: .valueChanged) // what function should be called when the fresher is triggered
        refresher.transform = CGAffineTransform(scaleX: 0.75, y: 0.75) // the size of the refresher
        refresher.tintColor = UIColor.systemPink // the color of the refresher
        refresher.layer.zPosition = -1 // this position will stop the refresher from layering on top of collection view items
        collectionView.addSubview(refresher) // add the refresher to the view
        
        // Step 4. Init the navigation bar
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // Step 5. Setup the navigation bar button (allows the user to select another photo album)
        let navBtn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        navBtn.setTitle("Select Album", for: .normal)
        navBtn.setTitleColor(.black, for: .normal)
        navBtn.titleLabel?.font = .systemFont(ofSize: 10)
        navBtn.addTarget(self, action: #selector(albumSelectorClicked), for: .touchUpInside) // what happens if the navigation bar button is clicked
        self.navigationItem.titleView = navBtn
        self.navigationController?.navigationBar.shadowImage = UIImage() // remove bottom line in navigation bar
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // Step 6. Setup options so that photos can be accessed
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        photos = PHAsset.fetchAssets(with: options)
    }
    
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    
    /*
     * FUNCTION : cropToBounds
     *
     * Crop a photo to a desired size, this will be used when filling the collection view
     */
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        // Step 1. Init the properties of the image
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // Step 2. See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Step 3. Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Step 4. Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }

    
    
    
    
    
    /*
     * FUNCTION : refresh
     *
     * What should happen when the refresher is triggered
     */
    @objc func refresh() {
        
        // Step 1. Fetch assets -> New assets will appear here
        photos = PHAsset.fetchAssets(with: options)
        
        // Step 2. Reload the collection view table
        collectionView.reloadData()
        
        // Step 3. Stop the refreshing animation
        refresher.endRefreshing()
    }
    
    
    
    
    
    /*
     * FUNCTION : viewDidAppear
     *
     * Just like the refresh function, if the view re-appeared, check if any other photos were taken
     */
    override func viewDidAppear(_ animated: Bool) {
        
        // Step 1. Fetch assets -> New assets will appear here
        photos = PHAsset.fetchAssets(with: options)
        
        // Step 2. Reload the collection view table
        collectionView.reloadData()
    }
    
    
    
    
    
    // MARK: - COLLECTION VIEW
    
    
    
    
    /*
     * FUNCTION : numberOfSections
     *
     * How many sections should appear in the collection view
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    
    /*
     * FUNCTION : numberOfItemsInSection
     *
     * How many items should appear in the collection view
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    
    
    
    /*
     * FUNCTION : didSelectItemAt
     *
     * This function will be called once a cell in the collection view is clicked
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Step 1. Store the index path
        selectedIndex = indexPath
        
        // Step 2. Show the navigation bar
        navigationController?.isNavigationBarHidden = false
        
        // Step 3. Append an add button to the navigation bar
        let button = UIImage(systemName: "arrow.right.circle") // add a system image to navigation bar
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: button, style: .plain, target: self, action: #selector(photoSelected)) // no animation when clicked
        navigationItem.setRightBarButton(UIBarButtonItem(image: button, style: .plain, target: self, action: #selector(photoSelected)), animated: true) // fade out when clicked
        
        // Step 4. Check if the user is clicking an already selected cell -> if they are, hide the navigation bar item
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.layer.borderWidth != Constants.kBORDERWIDTH {
                navigationItem.rightBarButtonItems?.removeFirst()
            }
        }
    }
    

    
    
    
    
    /*
     * FUNCTION : cellForItemAt
     *
     * Define the cell at the specific spot in the collection view
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Step 1. Define the cell that we will be using with the identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoLibraryCell
        
        // Step 2. Grab the PHAsset
        let asset = photos!.object(at: indexPath.row)
       
        // Step 3. Request the photo
        
        //PHImageManagerMaximumSize
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) -> Void in
            if (image == nil) { return }
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.image = self.cropToBounds(image: image!, width: 100, height: 100) // crop the photo so it fits in the cell
            cell.contentView.addSubview(imgView)
        }
        
        return cell
    }
    
    

    
    
    // MARK: - IBActions
    
    
    /*
     * FUNCTION : albumSelectorClicked
     *
     * If the navigation bar button was clicked
     */
    @objc func albumSelectorClicked(sender: UIButton) {
        
        // Step 1. Set the opacity of the button
        sender.alpha = 0.5
        
        // Step 2. How long the animation should be (after 0.5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //Bring's sender's opacity back up to fully opaque.
            sender.alpha = 1.0
        }
        
        // Step 3. Present the album list view controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "albumList") as! AlbumList
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    @objc func photoSelected(sender: UIButton) {
        
        // Step 1. Grab the PHAsset
        let asset = photos!.object(at: selectedIndex.row)
        let size = CGSize(width: 1000, height: 1000) // define the size of the photo we are grabbing
        
        // Step 2. Define the request options -> Get image in high quality
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .none
    
        // Step 3. Request the photo
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, userInfo) -> Void in
            if (image == nil) { return }
            
            // Step 4. Place the image in the next view controller
            let vc = self.storyboard?.instantiateViewController(identifier: "photoEditor") as! PhotoEditor
            vc.img = image!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
