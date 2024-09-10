//
//  ReciptModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 10/09/24.
//

import Foundation

// MARK: - ReciptModel
struct ReciptModel: Codable {
    let status: Int?
    let message: String?
    let data: [ReciptModelDatum]?
}

// MARK: - Datum
struct ReciptModelDatum: Codable {
    let id: Int?
    let receiptID: String?
    let billNo: Int?
    let refNo: String?
    let paymentType: Int?
    let transitionID: Int?
    let userID: Int?
    let invoiceID: String?
    let totalPaid, date, address, phoneNumber: String?
    let onlyReceiptID, createdBy: Int?
    let createdAt, updatedAt: String?
    let items: [ReciptModelItem]?
    let invoice: ReciptModelInvoice?

    enum CodingKeys: String, CodingKey {
        case id
        case receiptID = "receipt_id"
        case billNo = "bill_no"
        case refNo = "ref_no"
        case paymentType = "payment_type"
        case transitionID = "transition_id"
        case userID = "user_id"
        case invoiceID = "invoice_id"
        case totalPaid = "total_paid"
        case date, address
        case phoneNumber = "phone_number"
        case onlyReceiptID = "only_receipt_id"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case items, invoice
    }
}

// MARK: - Item
struct ReciptModelItem: Codable {
    let id, receiptID: Int?
    let description: String?
    let amount: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case receiptID = "receipt_id"
        case description, amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Invoice
struct ReciptModelInvoice: Codable {
    let invoiceID: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case invoiceID = "invoice_id"
        case id
    }
}
