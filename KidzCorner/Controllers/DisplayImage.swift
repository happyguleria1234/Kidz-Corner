//
//  DisplayImage.swift
//  KidzCorner
//
//  Created by Nikhil Jaggi on 26/03/24.
//

import UIKit
import Photos

class DisplayImage: UIViewController {
    
    var imageToDisplay: UIImage?
    
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var buttonDownload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImage()
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true, completion: {
            
        })
    }
    
    @IBAction func downloadFunc(_ sender: Any) {
        if let image = imageToDisplay {
            saveImageToAlbum(image: image)
        }
    }
    
    func displayImage() {
        DispatchQueue.main.async { [self] in
            if let image = imageToDisplay {
                imageMain.image = image
            }
        }
    }
    
    func saveImageToAlbum(image: UIImage) {
        var albumName = "Kidz Corner"
        
        // Check if the album exists
        var albumPlaceholder: PHObjectPlaceholder?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if collection.firstObject == nil {
            // Album does not exist, create it
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    // Created album, now save the image
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder!.localIdentifier], options: nil)
                    self.saveImageToAssetCollection(image: image, assetCollection: collectionFetchResult.firstObject!)
                } else {
                    print("Error creating album: \(String(describing: error))")
                }
            })
        } else {
            // Album exists, save the image
            saveImageToAssetCollection(image: image, assetCollection: collection.firstObject!)
        }
    }

    private func saveImageToAssetCollection(image: UIImage, assetCollection: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset else { return }
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            let enumeration: NSArray = [assetPlaceholder]
            albumChangeRequest?.addAssets(enumeration)
        }, completionHandler: { success, error in
            if success {
                printt("Successfully saved image to album")
                Toast.show(message: "Successfully saved image to album", controller: self)
            } else {
                Toast.show(message: "Error saving image: \(String(describing: error))", controller: self)
                printt("Error saving image: \(String(describing: error))")
            }
        })
    }
    
    
}
