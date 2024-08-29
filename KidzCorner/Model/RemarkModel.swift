//
//  RemarkModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 28/08/24.
//

import Foundation

// MARK: - User
struct RemarkModelData: Codable {
    let roleID: Int
    let createdAt: String?
    let id: Int
    let isLogin: Int
    let isChat: Int
    let showSchoolToHeadquarter: String?
    let address: String
    let countryID: Int
    let activeChildID: String?
    let dob: String?
    let quickbooksID: String?
    let leavePlanID: Int?
    let userLoginType: String
    let deviceToken: String
    let assignedForm: Int
    let selectedYear: String?
    let assignSchools: String?
    let userStatus: String
    let email: String
    let createdBy: Int
    let image: String
    let name: String
    let status: String
    let active: Int
    let chatToken: String
    let deviceType: Int
    let adminApprove: String
    let updatedAt: String
    let contactNumber: String
    let gender: String?
    let emailVerifiedAt: String?
    let document: String?
    let lastLogin: String
    let facebookAccessToken: String?
    let toyyibpaySecret: String?
    let toyyibpayUsername: String?
    let toyyibpayCategory: String?
    let classID: Int
}

// MARK: - Comment
struct RemarkModelDataComment: Codable {
    let height: String?
    let weight: String?
    let createdBy: Int
    let id: Int
    let createdAt: String
    let date: String
    let userID: Int
    let description: String
    let updatedAt: String
    let isActive: String
    let user: User
}

// MARK: - Response
struct RemarkModelDataCommentResponse: Codable {
    let status: Int
    let message: String
    let data: [Comment]
}
