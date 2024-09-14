//
//  ChildrenModel.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 17/10/23.
//

import Foundation

// MARK: - AllChildrenModel
struct AllChildrenModel: Codable {
    var status: Int?
    var message: String?
    var data: [ChildData]?
}

// MARK: - ChildData
struct ChildData: Codable {
    var id: Int?
    var dob: String?
    var studentProfile: StudentbvProfile?
    var name, image: String?

    enum CodingKeys: String, CodingKey {
        case id, dob
        case studentProfile = "student_profile"
        case name, image
    }
}

//// MARK: - StudentProfile
struct StudentbvProfile: Codable {
    var id: Int?
    var className: ClassNamee?
    var rotationID, permitPermission, userID, classStatus: Int?
    var enrollmentDate, updatedAt: String?
    var classID: Int?
    var status: Int?
    var endingDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case className = "class_name"
        case rotationID = "rotation_id"
        case permitPermission = "permit_permission"
        case userID = "user_id"
        case classStatus = "class_status"
        case enrollmentDate = "enrollment_date"
        case updatedAt = "updated_at"
        case classID = "class_id"
        case status
        case endingDate = "ending_date"
    }
}

struct ClassNamee: Codable {
    let id: Int?
    let name: String?
}


struct CommonModel: Codable {
    var status: Int?
    var message: String?
}

struct MedicationData {
    var date: [String]?
    var howManyTimeDay: [String]?
    var beforeLunch: [String]?
    var afterLunch: [String]?
}


import Foundation

// MARK: - MedicalModel
struct MedicalModel: Codable {
    let status: Int?
    let message: String?
    let data: MedicalModelDataClass?
}

// MARK: - DataClass
struct MedicalModelDataClass: Codable {
    let userID, remark: String?
    let schoolID: Int?
    let updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case remark
        case schoolID = "school_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
