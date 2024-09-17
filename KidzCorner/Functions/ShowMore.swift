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
    private let showMoreText = " Show More"
    private let showLessText = " Show Less"
    
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
            self.attributedText = truncatedText
        } else {
            self.text = text
            self.numberOfLines = 0 // Full text since it's not truncated
        }
    }
    
    @objc private func toggleLabelDescription() {
        self.isExpanded.toggle()
        
        if self.isExpanded {
            // Show full text with 'Show Less' at the end
            let fullText = originalText
            let fullAttributedString = NSMutableAttributedString(string: fullText)
            let showLessAttributedString = NSAttributedString(
                string: showLessText,
                attributes: [
                    .foregroundColor: UIColor.blue,
                    .font: self.font
                ]
            )
            fullAttributedString.append(showLessAttributedString)
            self.attributedText = fullAttributedString
            self.numberOfLines = expandedMaxLines // No limit
        } else {
            // Collapse back to truncated text with 'Show More'
            let truncatedText = getTruncatedText(for: originalText, maxLines: initialMaxLines)
            self.attributedText = truncatedText
            self.numberOfLines = initialMaxLines
        }
        
        // Trigger a layout update for the containing table view
        if let tableView = self.superview?.superview as? UITableView {
            tableView.beginUpdates()  // Start the update
            tableView.endUpdates()    // End the update (triggers the height change)
        }
    }
    
    private func isTextTruncated(text: String, maxLines: Int) -> Bool {
        let maxSize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let labelHeight = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.font!],
            context: nil).height
        
        let maxHeight = self.font.lineHeight * CGFloat(maxLines)
        return labelHeight > maxHeight
    }
    
    private func getTruncatedText(for text: String, maxLines: Int) -> NSAttributedString {
        let maxSize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let label = UILabel()
        label.font = self.font
        label.numberOfLines = maxLines
        label.text = text
        
        let words = text.split(separator: " ")
        var truncatedText = ""
        
        for word in words {
            let testText = truncatedText + "\(word) "
            label.text = testText
            let currentHeight = label.sizeThatFits(maxSize).height
            if currentHeight > self.font.lineHeight * CGFloat(maxLines) {
                truncatedText += "..."
                let attributedString = NSMutableAttributedString(string: truncatedText)
                let showMoreAttributedString = NSAttributedString(
                    string: showMoreText,
                    attributes: [
                        .foregroundColor: UIColor.blue,
                        .font: self.font
                    ]
                )
                attributedString.append(showMoreAttributedString)
                return attributedString
            }
            truncatedText += "\(word) "
        }
        
        return NSAttributedString(string: text)
    }
}
