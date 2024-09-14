//
//  ShowMore.swift
//  KidzCorner
//
//  Created by Happy Guleria on 12/09/24.
//

import UIKit

class ExpandableLabel: UILabel {
    private var originalText: String = ""
    private var isExpanded: Bool = false
    private let initialMaxLines: Int = 2
    private let expandedMaxLines: Int = 0 // 0 means no limit

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLabelDescription))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    func configureLabelDescription(text: String) {
        self.originalText = text
        self.isExpanded = false
        self.numberOfLines = initialMaxLines
        
        if isTextTruncated(text: text, maxLines: initialMaxLines) {
            let truncatedText = getTruncatedText(for: text, maxLines: initialMaxLines)
            let showMoreText = " Show More"
            let showMoreAttributedString = NSAttributedString(
                string: showMoreText,
                attributes: [
                    .foregroundColor: UIColor.blue,
                    .font: self.font
                ]
            )
            let attributedText = NSMutableAttributedString(attributedString: truncatedText)
            attributedText.append(showMoreAttributedString)
            self.attributedText = attributedText
        } else {
            self.text = text
            self.numberOfLines = 0
        }
    }
    
    @objc private func toggleLabelDescription() {
        self.isExpanded.toggle()
        
        if self.isExpanded {
            let fullText = originalText
            let showLessText = " Show Less"
            let showLessAttributedString = NSAttributedString(
                string: showLessText,
                attributes: [
                    .foregroundColor: UIColor.blue,
                    .font: self.font
                ]
            )
            let fullAttributedString = NSMutableAttributedString(string: fullText)
            fullAttributedString.append(showLessAttributedString)
            self.attributedText = fullAttributedString
            self.numberOfLines = 0
        } else {
            configureLabelDescription(text: originalText)
        }
        
        // Trigger a layout update for the containing table view
        if let tableView = self.superview?.superview as? UITableView {
            let indexPath = tableView.indexPath(for: self.superview as! UITableViewCell)!
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    
//    @objc private func toggleLabelDescription() {
//        self.isExpanded.toggle()
//        
//        if self.isExpanded {
//            let fullText = originalText
//            let showLessText = " Show Less"
//            let showLessAttributedString = NSAttributedString(
//                string: showLessText,
//                attributes: [
//                    .foregroundColor: UIColor.blue,
//                    .font: self.font
//                ]
//            )
//            let fullAttributedString = NSMutableAttributedString(string: fullText)
//            fullAttributedString.append(showLessAttributedString)
//            self.attributedText = fullAttributedString
//            self.numberOfLines = expandedMaxLines
//        } else {
//            configureLabelDescription(text: originalText)
//        }
//        
//        // Trigger a layout update for the containing table view (if necessary)
//        if let tableView = self.superview as? UITableView {
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
//    }
    
    private func isTextTruncated(text: String, maxLines: Int) -> Bool {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.font
        label.text = text
        
        let maxSize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let fullTextHeight = label.sizeThatFits(maxSize).height
        
        let maxLineHeight = self.font.lineHeight * CGFloat(maxLines)
        
        return fullTextHeight > maxLineHeight
    }
    
    private func getTruncatedText(for text: String, maxLines: Int) -> NSAttributedString {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.font
        label.text = text
        
        let maxSize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let maxLineHeight = self.font.lineHeight * CGFloat(maxLines)
        
        var truncatedText = ""
        var truncatedAttributedString: NSMutableAttributedString
        
        let words = text.split(separator: " ")
        for (index, word) in words.enumerated() {
            truncatedText += "\(word) "
            label.text = truncatedText + "..."
            
            let currentHeight = label.sizeThatFits(maxSize).height
            if currentHeight > maxLineHeight {
                truncatedAttributedString = NSMutableAttributedString(string: truncatedText)
                truncatedAttributedString.append(NSAttributedString(
                    string: "... Show More",
                    attributes: [
                        .foregroundColor: UIColor.blue,
                        .font: self.font
                    ]
                ))
                return truncatedAttributedString
            }
        }
        
        return NSAttributedString(string: text)
    }
}
