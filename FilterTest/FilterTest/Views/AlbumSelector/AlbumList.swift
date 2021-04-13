//
//  AlbumList.swift
//  FilterTest
//
//  Created by Sky Roth on 2021-04-02.
//

import UIKit
import Photos

class AlbumList: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var albumList = PHFetchResult<PHAssetCollection>()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "albumCell", bundle: nil), forCellReuseIdentifier: "albumCell")
        
        self.transitioningDelegate = self
        
        albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    }


   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albumList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! albumCell
        
        let album = albumList.object(at: indexPath.row)
        cell.albumNameLbl.text = album.localizedTitle

        return cell
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
