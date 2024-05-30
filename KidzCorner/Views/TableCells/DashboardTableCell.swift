import UIKit
import SDWebImage

class DashboardTableCell: UITableViewCell {
    
    var cellContent: [PortfolioImage]?
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var buttonMore: UIButton!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var viewDomain: UIView!
    @IBOutlet weak var labelDomain: UILabel!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonComment: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    @IBOutlet weak var viewUnreadComments: UIView!
    @IBOutlet weak var viewInsideUnreadComments: UIView!
    
    @IBOutlet weak var textWriteComment: UITextField!
    @IBOutlet weak var buttonWriteComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setupCollection()
        setupTextField()
    }
    
    func setupTextField() {
        // Customize the text field appearance
        textWriteComment.text = "Write a comment."
        textWriteComment.layer.cornerRadius = 22.5 // Set the corner radius as needed
        textWriteComment.layer.borderWidth = 1.0 // Set the border width as needed
        textWriteComment.textColor = .darkGray // Set the text color as needed
        textWriteComment.font = UIFont.systemFont(ofSize: 14) // Set the font size as needed
        textWriteComment.layer.masksToBounds = false
        textWriteComment.layer.masksToBounds = true
        textWriteComment.layer.borderColor = UIColor.clear.cgColor
    }
    
    func hideUnreadCommentViews(_ hide: Bool) {
        if hide == true {
            viewUnreadComments.isHidden = true
            viewInsideUnreadComments.isHidden = true
        }
        else {
            viewUnreadComments.isHidden = false
            viewInsideUnreadComments.isHidden = false
        }
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            viewOuter.layer.cornerRadius = 20
            imageProfile.layer.cornerRadius = imageProfile.bounds.height/2.0
            collectionImages.layer.cornerRadius = 20
            
            viewDomain.layer.cornerRadius = viewDomain.bounds.height/2.0
            
            viewUnreadComments.layer.borderColor = myGreenColor.cgColor
            viewUnreadComments.layer.borderWidth = 5
            viewUnreadComments.layer.cornerRadius = viewUnreadComments.bounds.height/2.0
            viewInsideUnreadComments.layer.cornerRadius = viewInsideUnreadComments.bounds.height/2.0
        }
    }
    
    func setupCollection() {
        collectionImages.register(UINib(nibName: "DashboardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionCell")
        collectionImages.delegate = self
        collectionImages.dataSource = self
    }
    
    @IBAction func moreFunc(_ sender: Any) {
    }
    
    @IBAction func likeFunc(_ sender: Any) {
    }
    
    @IBAction func commentFunc(_ sender: Any) {
    }
    
    @IBAction func shareFunc(_ sender: Any) {
    }
}

extension DashboardTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = cellContent?.count ?? 0
        return cellContent?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionCell", for: indexPath) as! DashboardCollectionCell
        print(cellContent?.count)
        let portfolioData = self.cellContent?[indexPath.row]
        if let memType = portfolioData?.memType {
            switch memType {
            case portfolioType.pdf.rawValue:
                printt("pdf")
                cell.imagePost.image = UIImage(named: "pdfIcon")
            case portfolioType.image.rawValue:
                if let url = URL(string: imageBaseUrl+(cellContent?[indexPath.item].image ?? "")) {
                    print(url)
                    cell.imagePost.sd_setImage(with: url, placeholderImage: .placeholderImage)
                }
            default: break
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let portfolioData = self.cellContent?[indexPath.row]
        if let memType = portfolioData?.memType {
            switch memType {
            case portfolioType.pdf.rawValue:
                printt("pdf")
                if let urlStr = portfolioData?.image, let url = URL(string: imageBaseUrl + urlStr) {
                    UIApplication.shared.open(url)
                }
            default: break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            
            pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImages.bounds.width, height: collectionImages.bounds.height)
    }
    
}

enum portfolioType: String {
    case image = "1"
    case video = "2"
    case pdf = "3"
}
