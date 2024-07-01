import Foundation

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
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
