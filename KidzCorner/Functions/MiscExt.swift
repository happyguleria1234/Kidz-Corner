import Foundation

extension UITableView {

    func setNoDataMessage(_ message: String,txtColor : UIColor = .black,yPosition : CGFloat = -50) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noData")
        view.addSubview(imageView)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = txtColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.sizeToFit()
        view.addSubview(messageLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yPosition), // Adjust this value for vertical positioning
            imageView.widthAnchor.constraint(equalToConstant: 200), // Adjust the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 150), // Adjust the height as needed
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: self.bounds.width - 60), // Adjust the width as needed
        ])
        self.backgroundView = view
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UITableView {

//    func scrollToBottom(isAnimated:Bool = true){
//
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(
//                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
//                section: self.numberOfSections - 1)
//            if self.hasRowAtIndexPath(indexPath: indexPath) {
//                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
//            }
//        }
//    }
    
    func scrollToBottom(isAnimated: Bool = true) {
        DispatchQueue.main.async {
            let numberOfSections = self.numberOfSections
            guard numberOfSections > 0 else {
                // No sections available
                return
            }

            let lastSection = numberOfSections - 1
            let numberOfRowsInLastSection = self.numberOfRows(inSection: lastSection)
            guard numberOfRowsInLastSection > 0 else {
                // No rows in the last section
                return
            }

            let indexPath = IndexPath(row: numberOfRowsInLastSection - 1, section: lastSection)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

//    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
//        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
//    }
}
