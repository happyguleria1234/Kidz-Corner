//
//  PayloadModel.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 01/07/23.
//

import Foundation

// MARK: - Welcome
struct PayloadModel: Codable {
    let data: PayloadData?
}

// MARK: - PayloadData
struct PayloadData: Codable {
    let id, type: Int?
}
