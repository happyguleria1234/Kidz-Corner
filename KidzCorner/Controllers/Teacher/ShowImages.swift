//
//  ShowImages.swift
//  KidzCorner
//
//  Created by Happy Guleria on 31/07/24.
//
import UIKit
import SDWebImage
import Foundation


var comesForImages = String()

class ShowImages : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnDownload: UIButton!
    var strImagesArr = [PortfolioImage]()
    var imagesArr = [UIImage]()
    var selectedIndex = Int()
    var comesFrom = String()
    @IBOutlet weak var collectionImages: UICollectionView!
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strImagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesShowCell", for: indexPath) as! ImagesShowCell
        if let url = URL(string: imageBaseUrl + (strImagesArr[indexPath.item].image ?? "")) {
            cell.imageShow.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
        if comesFrom == "dashboard" {
            comesForImages = "Images"
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionImages.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.collectionView?.isPagingEnabled = true
        }
        if comesFrom == "dashboard" {
            btnDownload.isHidden = true
        }
        collectionImages.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let index = IndexPath(item: selectedIndex, section: 0)
        collectionImages.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //------------------------------------------------------
}


class ImagesShowCell: UICollectionViewCell {
    
    @IBOutlet weak var imageShow: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
