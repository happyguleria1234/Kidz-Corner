//
//  TeacherPortfolioModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/07/24.
//
import Foundation

// MARK: - AlbumModel
struct AlbumModelDataa: Codable {
    let status: Int?
    let message: String?
    let data: AlbumModelDataaDataClass?
}

// MARK: - DataClass
struct AlbumModelDataaDataClass: Codable {
    let currentPage: Int?
    let data: [AlbumModelDataaDatum]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [AlbumModelDataaLink]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct AlbumModelDataaDatum: Codable {
    let id: Int?
    let parentID: Int?
    let userID: Int?
    let classID: Int?
    let type: Int?
    let companyID, teacherID: Int?
    let skillID: Int?
    let domainID, ageGroupID, /*isApproved*/ isCollage: Int?
    let postDate, title: String?
    let pdfFile: String?
    let isDashboard: Int?
    let postContent, postType: String?
    let isFacebookPost: Int?
    let publishDate, facebookID: String?
    let approveDate: String?
    let facebookPostID, pageID: Int?
    let portfolioType: Int?
    let createdAt, updatedAt: String?
    let domain: AlbumModelDataaDomain?
    let teacher: AlbumModelDataaTeacher?
    let portfolioImage: [PortfolioImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case userID = "user_id"
        case classID = "class_id"
        case type
        case companyID = "company_id"
        case teacherID = "teacher_id"
        case skillID = "skill_id"
        case domainID = "domain_id"
        case ageGroupID = "age_group_id"
//        case isApproved = "is_approved"
        case isCollage = "is_collage"
        case postDate = "post_date"
        case title
        case pdfFile = "pdf_file"
        case isDashboard = "is_dashboard"
        case postContent = "post_content"
        case postType = "post_type"
        case isFacebookPost = "is_facebook_post"
        case publishDate = "publish_date"
        case facebookID = "facebook_id"
        case approveDate = "approve_date"
        case facebookPostID = "facebook_post_id"
        case pageID = "page_id"
        case portfolioType = "portfolio_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case domain, teacher
        case portfolioImage = "portfolio_image"
    }
}

// MARK: - Domain
struct AlbumModelDataaDomain: Codable {
    let id, createdBy: Int?
    let name: String?
    let isacive: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case name, isacive
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - PortfolioImage
struct AlbumModelDataaPortfolioImage: Codable {
    let id, portfolioID, classID, companyID: Int?
    let memType: String?
    let albumID: Int?
    let image: String?
    let userID: Int?
//    let isApproved: Int?
    let approveDate, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioID = "portfolio_id"
        case classID = "class_id"
        case companyID = "company_id"
        case memType = "mem_type"
        case albumID = "album_id"
        case image
        case userID = "user_id"
//        case isApproved = "is_approved"
        case approveDate = "approve_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Teacher
struct AlbumModelDataaTeacher: Codable {
    let id: Int?
    let toyyibpayUsername, toyyibpaySecret, toyyibpayCategory, facebookAccessToken: String?
    let classID: Int?
    let activeChildID: Int?
    let name: String?
    let quickbooksID: Int?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt: String?
    let image: String?
    let document: String?
    let address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let userLoginType, adminApprove, createdAt, updatedAt: String?
    let userStatus, chatToken: String?
    let active: Int?
    let dob: String?
    let leavePlanID: Int?
    let deviceToken: String?
    let deviceType, assignedForm, countryID: Int?
    let assignSchools: String?
    let selectedYear: String?
    let showSchoolToHeadquarter: String?
    let lastLogin: String?

    enum CodingKeys: String, CodingKey {
        case id
        case toyyibpayUsername = "toyyibpay_username"
        case toyyibpaySecret = "toyyibpay_secret"
        case toyyibpayCategory = "toyyibpay_category"
        case facebookAccessToken = "facebook_access_token"
        case classID = "class_id"
        case activeChildID = "active_child_id"
        case name
        case quickbooksID = "quickbooks_id"
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, document, address
        case contactNumber = "contact_number"
        case gender, islogin
        case userLoginType = "user_login_type"
        case adminApprove = "admin_approve"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userStatus = "user_status"
        case chatToken = "chat_token"
        case active, dob
        case leavePlanID = "leave_plan_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case assignedForm = "assigned_form"
        case countryID = "country_id"
        case assignSchools = "assign_schools"
        case selectedYear = "selected_year"
        case showSchoolToHeadquarter = "show_school_to_headquarter"
        case lastLogin = "last_login"
    }
}

// MARK: - Link
struct AlbumModelDataaLink: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
