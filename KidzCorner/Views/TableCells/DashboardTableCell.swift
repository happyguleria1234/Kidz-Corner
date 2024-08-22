import UIKit
import Lightbox
import SDWebImage

class DashboardTableCell: UITableViewCell {
    
    var cellContent: [PortfolioImage]?
    var postData: DashboardModelData?
    var postData2: ChildPortfolioModelData?
    var comesFrom = String()
    var isCollage = Int()
    var view = UIViewController()
    
    var isExpanded: Bool = false
    var originalText: String = ""
    var truncatedText: NSAttributedString = NSAttributedString()
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDomain: UIView!
    @IBOutlet weak var labelDomain: UILabel!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var likeCommentView: UIView!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonComment: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var viewUnreadComments: UIView!
    @IBOutlet weak var viewInsideUnreadComments: UIView!
    @IBOutlet weak var likeCommentviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textWriteComment: UITextField!
    @IBOutlet weak var buttonWriteComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setupCollection()
        setupTextField()
        setupLabelDescription()
    }
    
    private func setupLabelDescription() {
        // Add tap gesture to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLabelDescription))
        labelDescription.isUserInteractionEnabled = true
        labelDescription.addGestureRecognizer(tapGesture)
    }
    
    func configureLabelDescription(text: String, maxLines: Int = 4) {
        originalText = text
        truncatedText = getTruncatedText(for: text, maxLines: maxLines)
        labelDescription.attributedText = truncatedText // Use attributedText instead of text
        labelDescription.numberOfLines = isExpanded ? 0 : maxLines
    }
    
    @objc private func toggleLabelDescription() {
        isExpanded.toggle()
        
        if isExpanded {
            let fullText = originalText as NSString
            let showLessText = " Show Less"
            let showLessAttributedString = NSAttributedString(
                string: showLessText,
                attributes: [
                    .foregroundColor: UIColor.blue,
                    .font: labelDescription.font
                ]
            )
            let fullAttributedString = NSMutableAttributedString(string: originalText)
            fullAttributedString.append(showLessAttributedString)
            labelDescription.attributedText = fullAttributedString
            labelDescription.numberOfLines = 0
        } else {
            labelDescription.attributedText = getTruncatedText(for: originalText, maxLines: 4)
            labelDescription.numberOfLines = 4
        }
        
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    private func getTruncatedText(for text: String, maxLines: Int) -> NSAttributedString {
        // Create a UILabel to measure text
        let label = UILabel()
        label.numberOfLines = 0
        label.font = labelDescription.font
        label.text = text
        
        // Calculate the maximum height for the allowed number of lines
        let maxSize = CGSize(width: labelDescription.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let fullTextHeight = label.sizeThatFits(maxSize).height
        
        let maxLineHeight = label.font.lineHeight * CGFloat(maxLines)
        
        // Check if the text exceeds the maximum height for the allowed lines
        if fullTextHeight > maxLineHeight {
            var truncatedText = ""
            var truncatedAttributedString: NSMutableAttributedString
            
            // Find where to cut off the text
            for word in text.split(separator: " ") {
                truncatedText += "\(word) "
                label.text = truncatedText + "..."
                
                let currentHeight = label.sizeThatFits(maxSize).height
                if currentHeight > maxLineHeight {
                    // Append "Show More" at the end
                    truncatedAttributedString = NSMutableAttributedString(string: truncatedText)
                    truncatedAttributedString.append(NSAttributedString(
                        string: "... Show More",
                        attributes: [
                            .foregroundColor: UIColor.blue,
                            .font: labelDescription.font
                        ]
                    ))
                    return truncatedAttributedString
                }
            }
        }
        
        // If no truncation is needed, return the full text
        return NSAttributedString(string: text)
    }
    
    func setupTextField() {
        textWriteComment.text = "Write a comment."
        textWriteComment.layer.cornerRadius = 22.5
        textWriteComment.layer.borderWidth = 1.0
        textWriteComment.textColor = .darkGray
        textWriteComment.font = UIFont.systemFont(ofSize: 14)
        textWriteComment.layer.masksToBounds = true
        textWriteComment.layer.borderColor = UIColor.clear.cgColor
        //        pageControl.isHidden = true
    }
    
    func hideUnreadCommentViews(_ hide: Bool) {
        viewUnreadComments.isHidden = hide
        viewInsideUnreadComments.isHidden = hide
    }
    
    func setupViews() {
        DispatchQueue.main.async {
            self.viewOuter.layer.cornerRadius = 20
            self.imageProfile.layer.cornerRadius = self.imageProfile.bounds.height / 2.0
            self.collectionImages.layer.cornerRadius = 20
            self.viewDomain.layer.cornerRadius = self.viewDomain.bounds.height / 2.0
            self.viewUnreadComments.layer.borderColor = myGreenColor.cgColor
            self.viewUnreadComments.layer.borderWidth = 5
            self.viewUnreadComments.layer.cornerRadius = self.viewUnreadComments.bounds.height / 2.0
            self.viewInsideUnreadComments.layer.cornerRadius = self.viewInsideUnreadComments.bounds.height / 2.0
        }
    }
    
    func setupCollection() {
        collectionImages.register(UINib(nibName: "DashboardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionCell")
        collectionImages.delegate = self
        collectionImages.dataSource = self
        let layout = CustomCollectionViewLayout()
        collectionImages.collectionViewLayout = layout
        collectionImages.isScrollEnabled = false
    }
    
    @IBAction func likeFunc(_ sender: Any) {
        // Like action implementation
    }
    
    @IBAction func commentFunc(_ sender: Any) {
        // Comment action implementation
    }
    
    @IBAction func shareFunc(_ sender: Any) {
        // Share action implementation
    }
}

extension DashboardTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = min(cellContent?.count ?? 0, 9)
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionCell", for: indexPath) as! DashboardCollectionCell
        let portfolioData = self.cellContent?[indexPath.row]
        if let memType = portfolioData?.memType {
            switch memType {
            case portfolioType.pdf.rawValue:
                cell.imagePost.image = UIImage(named: "pdfIcon")
            case portfolioType.image.rawValue:
                if let url = URL(string: imageBaseUrl + (cellContent?[indexPath.item].image ?? "")) {
                    cell.imagePost.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
                    //                    loadImage(with: url, into: cell.imagePost, targetSize: CGSize(width: 200, height: 200))
                }
            default: break
            }
        }
        cell.imagePost.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let portfolioData = self.cellContent?[indexPath.row]
        if let memType = portfolioData?.memType {
            switch memType {
            case portfolioType.pdf.rawValue:
                if let url = URL(string: imageBaseUrl + (self.cellContent?[indexPath.row].image ?? "")) {
                    UIApplication.shared.open(url)
                }
            case portfolioType.image.rawValue:
                var images = [LightboxImage]()
                cellContent?.forEach({ imgData in
                    images.append(LightboxImage(imageURL: URL(string: "\(imageBaseUrl)\(imgData.image ?? "")")!))
                })
                let controller = LightboxController(images: images)
                controller.dynamicBackground = true
                controller.goTo(0)
                self.view.present(controller, animated: true) {
                    comesForImages = "Images"
                }
//                let storyboard = UIStoryboard(name: "Parent", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "ShowImages") as! ShowImages
//                vc.strImagesArr = cellContent ?? []
//                vc.selectedIndex = indexPath.item
//                vc.comesFrom = "dashboard"
//                vc.modalPresentationStyle = .fullScreen
//                self.view.present(vc, animated: true)
            default: break
            }
        }
    }
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    private let cellPadding: CGFloat = 1
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        let itemCount = collectionView.numberOfItems(inSection: 0)
        guard itemCount > 0 else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        if itemCount == 3 {
            // Specific layout for 3 items
            let largeCellWidth = contentWidth / 2
            let smallCellWidth = contentWidth / 2
            let smallCellHeight = collectionView.bounds.height / 2
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let frame: CGRect
                
                switch item {
                case 0:
                    frame = CGRect(x: 0, y: 0, width: largeCellWidth, height: collectionView.bounds.height)
                case 1:
                    frame = CGRect(x: largeCellWidth, y: 0, width: smallCellWidth, height: smallCellHeight)
                case 2:
                    frame = CGRect(x: largeCellWidth, y: smallCellHeight, width: smallCellWidth, height: smallCellHeight)
                default:
                    continue
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        } else if itemCount == 4 {
            // Specific layout for 4 items: 2x2 grid
            let width = contentWidth / 2
            let height = collectionView.bounds.height / 2
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let row = item / 2
                let column = item % 2
                
                let xOrigin = CGFloat(column) * width
                let yOrigin = CGFloat(row) * height
                let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        } else if itemCount == 5 {
            // Specific layout for 5 items: 2x2 grid + 1 full-height item in last column
            let smallCellWidth = contentWidth / 3
            let smallCellHeight = collectionView.bounds.height / 2
            let largeCellWidth = contentWidth / 3
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let frame: CGRect
                
                switch item {
                case 0:
                    frame = CGRect(x: 0, y: 0, width: smallCellWidth, height: smallCellHeight)
                case 1:
                    frame = CGRect(x: 0, y: smallCellHeight, width: smallCellWidth, height: smallCellHeight)
                case 2:
                    frame = CGRect(x: smallCellWidth, y: 0, width: smallCellWidth, height: smallCellHeight)
                case 3:
                    frame = CGRect(x: smallCellWidth, y: smallCellHeight, width: smallCellWidth, height: smallCellHeight)
                case 4:
                    frame = CGRect(x: 2 * smallCellWidth, y: 0, width: largeCellWidth, height: collectionView.bounds.height)
                default:
                    continue
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        } else if itemCount == 6 {
            // Specific layout for 6 items: 2 rows and 3 items in each row
            let width = contentWidth / 3
            let height = collectionView.bounds.height / 2
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let row = item / 3
                let column = item % 3
                
                let xOrigin = CGFloat(column) * width
                let yOrigin = CGFloat(row) * height
                let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        } else if itemCount >= 7 && itemCount <= 9 {
            // Specific layout for 7-9 items: 3x3 grid
            let width = contentWidth / 3
            let height = collectionView.bounds.height / 3
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let row = item / 3
                let column = item % 3
                
                let xOrigin = CGFloat(column) * width
                let yOrigin = CGFloat(row) * height
                let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        } else {
            // Original layout logic for other cases
            let rowOrColoumnCount = 3
            let quotient = quotientValue(for: itemCount)
            let mode = modeValue(for: itemCount)
            let fullyDivided = isFullyDivided(forMode: mode)
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: 0)
                let rowIndex = rowIndexForItem(at: item, itemCount: itemCount)
                let isRemainingRow = rowIndex.1 == quotient
                
                let widthDivider: CGFloat = !isRemainingRow ? CGFloat(rowOrColoumnCount) : CGFloat(mode)
                let heightDivider: CGFloat = fullyDivided ? CGFloat(quotient) : CGFloat(quotient + 1)
                
                let width = contentWidth / widthDivider
                let height = collectionView.bounds.height / heightDivider
                let xOrigin = CGFloat(rowIndex.0) * width
                let yOrigin = CGFloat(rowIndex.1) * height
                
                let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                cache.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    private func rowIndexForItem(at index: Int, itemCount: Int) -> (Int, Int) {
        let rowOrColoumnCount = 3
        return (index % rowOrColoumnCount, index / rowOrColoumnCount)
    }
    
    private func modeValue(for itemCount: Int) -> Int {
        return itemCount % 3
    }
    
    private func isFullyDivided(forMode: Int) -> Bool {
        return forMode == 0
    }
    
    private func quotientValue(for itemCount: Int) -> Int {
        return itemCount / 3
    }
}

enum portfolioType: String {
    case image = "1"
    case video = "2"
    case pdf = "3"
}


func loadImage(with url: URL?, into imageView: UIImageView, targetSize: CGSize) {
    // Create the resizing transformer
    let transformer = SDImageResizingTransformer(size: targetSize, scaleMode: .aspectFill)
    
    // Load the image with SDWebImage, applying the transformer
    imageView.sd_setImage(with: url,
                          placeholderImage: .placeholderImage,
                          options: [.scaleDownLargeImages],
                          context: [.imageTransformer: transformer])
}
