//
//  EmojiManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 03/07/24.
//

import Foundation

class EmojiTextField: UITextView {

    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        
        for mode in UITextInputMode.activeInputModes {
            if self.tag == 0 {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
            if self.tag == 1 {
                if mode.primaryLanguage != "emoji" {
                    return mode
                }
            }
        }
        return nil
    }

}
