import Foundation

class ChildrenData {
    
    static var shared = ChildrenData()
    
    var data: [LoginModelData]?
    
    init(data: [LoginModelData]? = nil) {
        self.data = data
    }
}


// MARK: - BaseModel
struct BaseModel: Codable {
    let status: Int?
    let message: String?
    let data: [String]?
}

// MARK: - Login
struct LoginModel: Codable {
    let status: Int?
    let message: String?
    let data: LoginModelData?
}

struct LoginModelData: Codable {
    let id: Int?
    let name: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt, image, address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt, updatedAt, token: String?
    let childrenData: [LoginModelData]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case token
        case childrenData = "parents_children"
    }
}

// MARK: - Dashboard
struct DashboardModel: Codable {
    let status: Int?
    let message: String?
    var data: [DashboardModelData]?
}

// MARK: - Dashboard
struct DashboardModelNew: Codable {
    let status: Int?
    let message: String?
    var data: DashboardDataClass?
    let latest_version: String?
}

// MARK: - DashboardDataClass
struct DashboardDataClass: Codable {
    let from, perPage: Int?
    let data: [DashboardModelData]?
    let firstPageURL, nextPageURL: String?
    let currentPage: Int?
    let path: String?
    
    let prevPageURL: String?
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case from
        case perPage = "per_page"
        case data
        case firstPageURL = "first_page_url"
        case nextPageURL = "next_page_url"
        case currentPage = "current_page"
        case path
        case prevPageURL = "prev_page_url"
        case to
        
    }
}

struct DashboardModelData: Codable {
    let id, userID, teacherID, isApproved: Int?
    let skillID, domainID, ageGroupID: Int?
    let title: String?
    let postDate: String?
    let isDashboard: Int?
    let postContent: String?
    let createdAt, updatedAt: String?
    var totalComments, isLike: Int?
    var totalLikes: Int?
    var unreadComment: Int?
    let teacher, student: Student?
    let portfolioImage: [PortfolioImage]?
    let ageGroup: AgeGroup?
    let domain, skills: Domains?
    
    enum CodingKeys: String, CodingKey {
        case id
        case totalComments = "comment"
        case unreadComment
        case totalLikes = "likes_count"
        case isLike = "is_like"
        case skillID = "skill_id"
        case domainID = "domain_id"
        case ageGroupID = "age_group_id"
        case title
        case userID = "user_id"
        case teacherID = "teacher_id"
        case isApproved = "is_approved"
        case postDate = "post_date"
        case isDashboard = "is_dashboard"
        case postContent = "post_content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case teacher, student
        case portfolioImage = "portfolio_image"
        case ageGroup = "age_group"
        case domain, skills
    }
}

// MARK: - PortfolioImage
struct PortfolioImage: Codable {
    let id, portfolioID: Int?
    let image: String?
    let createdAt, updatedAt: String?
    let memType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case portfolioID = "portfolio_id"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case memType = "mem_type"
    }
}

// MARK: - Student
struct Student: Codable {
    let id: Int?
    let name: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt, image, address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt, updatedAt: String?
    let studentProfile: StudentProfile?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case studentProfile = "student_profile"
    }
}

struct TeacherData: Codable {
        let id: Int?
        let classID, activeChildID: Int?
        let name: String?
        let quickbooksID: String?
        let createdBy: Int?
        let status: String?
        let roleID: Int?
        let email: String?
        let emailVerifiedAt: String?
        let image: String?
        let document: String?
        let address, contactNumber, gender: String?
        let islogin: Int?
        let dob: String?
        let active, leavePlanID: Int?
        let deviceToken, createdAt: String?
        let deviceType: Int?
        let updatedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
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
            case gender, islogin, dob, active
            case leavePlanID = "leave_plan_id"
            case deviceToken = "device_token"
            case deviceType = "device_type"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    
}

// MARK: - ChildPortfolioModel
struct ChildPortfolioModel: Codable {
    let status: Int?
    let message: String?
    var data: [ChildPortfolioModelData]?
}

struct ChildPortfolioModelData: Codable {
    let id, userID, teacherID, isApproved: Int?
    let skillID, domainID, ageGroupID: Int?
    let title: String?
    let postDate: String?
    let isDashboard: Int?
    let postContent: String?
    let createdAt, updatedAt: String?
    let teacher: TeacherData?
    let student: Student?
    let portfolioImage: [PortfolioImage]?
    let ageGroup: AgeGroup?
    let domain, skills: Domains?
    var totalComments, isLike: Int?
    var unreadComment: Int?
    var totalLikes: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case skillID = "skill_id"
        case domainID = "domain_id"
        case ageGroupID = "age_group_id"
        case title
        case userID = "user_id"
        case teacherID = "teacher_id"
        case isApproved = "is_approved"
        case postDate = "post_date"
        case isDashboard = "is_dashboard"
        case postContent = "post_content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case teacher, student
        case portfolioImage = "portfolio_image"
        case ageGroup = "age_group"
        case domain, skills
        case totalComments = "comment"
        case isLike = "is_like"
        case totalLikes = "likes_count"
        case unreadComment
    }
}

// MARK: - AgeGroup
struct AgeGroup: Codable {
    let id: Int?
    let name: String?
    let isactive: Int?
}

// MARK: - Domains
struct Domains: Codable {
    let id: Int?
    let name: String?
    let agegroupID, isacive, domainID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case agegroupID = "agegroup_id"
        case isacive
        case domainID = "domain_id"
    }
}

// MARK: - CategoryModel
struct CategoryModel: Codable {
    let status: Int?
    let message: String?
    let data: CategoryModelData?
}

struct CategoryModelData: Codable {
        let album: [Album]?
        let domain: [Domain]?
    }

struct Album: Codable {
    let id: Int?
    let name: String?
    let createdBy, isactive: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdBy = "created_by"
        case isactive
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Domain
struct Domain: Codable {
    let id: Int?
    let name: String?
    let agegroupID, isacive: Int?
    let skills: [Skill]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case agegroupID = "agegroup_id"
        case isacive, skills
    }
}

// MARK: - Skill
struct Skill: Codable {
    let id: Int?
    let name: String?
    let domainID, isacive: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case domainID = "domain_id"
        case isacive
    }
}

// MARK: - AnnouncementModel
struct AnnouncementModel: Codable {
    let status: Int?
    let message: String?
    let data: [AnnouncementModelData]?
}

struct AnnouncementModelData: Codable {
    let id, userID: Int?
    let title, date, time, description: String?
    let active, classID, announcementType, isTeacher: Int?
    let createdByRole, createdBy: Int?
    let attachment, createdAt, updatedAt: String?
    let status: Int?
    let file: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, date, time
        case description = "description"
        case active
        case classID = "class_id"
        case announcementType = "announcement_type"
        case isTeacher = "is_teacher"
        case createdByRole = "created_by_role"
        case createdBy = "created_by"
        case attachment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case file
    }
}

// MARK: - AnnouncementChildren
struct AnnouncementChildrenModel: Codable {
    let status: Int?
    let message: String?
    let data: [AnnouncementChildrenModelData]?
}

// MARK: - DataClass
struct AnnouncementChildrenModelData: Codable {
        let id, userID, mainAnnoucementID, createdBy: Int?
        let createdByRole, isTeacher: Int?
        let title, date, time, announcementStatus: String?
        let announcmentDescription: String?
        let announcementType: Int?
        let type: String?
        let classID: Int?
        let attachment, file: String?
        let active: Int?
        let createdAt, updatedAt: String?
        let status: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case mainAnnoucementID = "main_annoucement_id"
            case createdBy = "created_by"
            case createdByRole = "created_by_role"
            case isTeacher = "is_teacher"
            case title, date, time
            case announcementStatus = "announcement_status"
            case announcmentDescription = "description"
            case announcementType = "announcement_type"
            case type
            case classID = "class_id"
            case attachment, file, active
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case status
        }
}

// MARK: - Children
struct AnnouncementChildren: Codable {
    let id, classID: Int?
        let name: String?
        let createdBy: Int?
        let status: String?
        let roleID: Int?
        let email, emailVerifiedAt: String?
        let image: String?
        let address, contactNumber: String?
        let gender: String?
        let islogin: Int?
        let dob: String?
        let active: Int?
        let createdAt: String?
        let updatedAt: String?
        let announcment: [Announcment]?

        enum CodingKeys: String, CodingKey {
            case id
            case classID = "class_id"
            case name
            case createdBy = "created_by"
            case status
            case roleID = "role_id"
            case email
            case emailVerifiedAt = "email_verified_at"
            case image, address
            case contactNumber = "contact_number"
            case gender, islogin, dob, active
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case announcment
        }
}

// MARK: - Announcment
struct Announcment: Codable {
    let id, mainAnnoucementID, userID: Int?
        let title, date, time, announcmentDescription: String?
        let active, classID: Int?
        let announcementType: Int?
        let announcementStatus: Int?
        let type: String?
        let isTeacher, createdByRole, createdBy: Int?
        let attachment, createdAt, updatedAt: String?
        let status: Int?
        let file: String?

        enum CodingKeys: String, CodingKey {
            case id
            case mainAnnoucementID = "main_annoucement_id"
            case userID = "user_id"
            case title, date, time
            case announcmentDescription = "description"
            case active
            case classID = "class_id"
            case announcementType = "announcement_type"
            case announcementStatus = "announcement_status"
            case type
            case isTeacher = "is_teacher"
            case createdByRole = "created_by_role"
            case createdBy = "created_by"
            case attachment
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case status
            case file
        }
}

struct ClassAttendanceModel: Codable {
    let status: Int?
    let message: String?
    let data: [ClassAttendanceModelData]?
}

// MARK: - Datum
struct ClassAttendanceModelData: Codable {
    let id: Int?
    let classID: Int?
    let name: String?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt: String?
    let image, address, contactNumber, gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt: String?
    let updatedAt: String?
    let className: ClassName?
    let attendance: Attendance?

    enum CodingKeys: String, CodingKey {
        case id
        case classID = "class_id"
        case name
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case className = "class_name"
        case attendance
    }
}

// MARK: - Attendance
struct Attendance: Codable {
    let id, userType, companyID, classID: Int?
    let userID: Int?
    let sendBy, pickBy, checkinHealth, checkoutHealth: Int?
    let reason: Int?
    let checkinNotes, checkoutNotes: String?
    let date, timeIn, timeOut: String?
    let morningTemp, eveningTemp: String?
    let status: String?
    let session: String?
    let createdAt, updatedAt: String?
    let thirdTemperature, thirdTemperatureTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userType = "user_type"
        case companyID = "company_id"
        case classID = "class_id"
        case userID = "user_id"
        case sendBy = "send_by"
        case pickBy = "pick_by"
        case checkinHealth = "checkin_health"
        case checkoutHealth = "checkout_health"
        case reason
        case checkinNotes = "checkin_notes"
        case checkoutNotes = "checkout_notes"
        case date
        case timeIn = "time_in"
        case timeOut = "time_out"
        case morningTemp = "morning_temp"
        case eveningTemp = "evening_temp"
        case status, session
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case thirdTemperature = "other_temp"
        case thirdTemperatureTime = "other_temp_time"
    }
}

// MARK: - GuardianListModel
struct GuardianListModel: Codable {
    let status: Int?
    let message: String?
    let data: GuardianListModelData?
}

struct GuardianListModelData: Codable {
    let id: Int?
    let name: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt, image, address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt, updatedAt: String?
    let childrenParents: [GuardianListModelData]?
    let pivot: Pivot?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case childrenParents = "children_parents"
        case pivot
    }
}

struct Pivot: Codable {
    let studentID, parentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case studentID = "student_id"
        case parentID = "parent_id"
    }
}


// MARK: - ChildAttendanceModel
struct ChildAttendanceModel: Codable {
    let status: Int?
    let message: String?
    let data: ChildAttendanceModelData?
}

struct ChildAttendanceModelData: Codable {
    let id, studentID, parentID: Int?
    let relation: String?
    let createdAt, updatedAt: String?
    let attendance: ChildAttendance?
    let children: Children?
    
    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case parentID = "parent_id"
        case relation
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attendance, children
    }
}

// MARK: - Attendance
struct ChildAttendance: Codable {
    let id, userID: Int?
    let sendBy, pickBy, sender, picker: Children?
    let date, timeIn: String?
    let timeOut: String?
    let morningTemp: String?
    let eveningTemp: String?
    let status: String?
    let session: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case sendBy = "send_by"
        case pickBy = "pick_by"
        case date
        case timeIn = "time_in"
        case timeOut = "time_out"
        case morningTemp = "morning_temp"
        case eveningTemp = "evening_temp"
        case status, session
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sender, picker
    }
}

// MARK: - Children
struct Children: Codable {
    let id: Int?
    let name: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt, image, address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt, updatedAt: String?
    let studentProfile: StudentProfile?
    let announcement: [Announcment]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case studentProfile = "student_profile"
        case announcement = "announcment"
    }
}

// MARK: - StudentProfile
struct StudentProfile: Codable {
    let id, userID, classID, rotationID: Int?
    let status: Int?
    let enrollmentDate: String?
    let createdAt, updatedAt: String?
    let className: ClassName?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case classID = "class_id"
        case rotationID = "rotation_id"
        case status
        case enrollmentDate = "enrollment_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case className = "class_name"
    }
}

// MARK: - StudentAttendanceModel
struct StudentAttendanceModel: Codable {
    let staus: Int?
    let message: String?
    let data: StudentAttendanceData?
}

// MARK: - StudentAttendace
struct StudentAttendance: Codable {
    let id, userType, companyID, classID: Int?
        let userID: Int?
        let sendBy, pickBy, sender, picker: StudentAttendanceData?
        let checkinHealth, checkoutHealth, reason: Int?
        let checkinNotes, checkoutNotes: String?
        let date, timeIn: String?
        let timeOut: String?
        let morningTemp: String?
        let eveningTemp: String?
        let status: String?
        let session: String?
        let createdAt, updatedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userType = "user_type"
            case companyID = "company_id"
            case classID = "class_id"
            case userID = "user_id"
            case sendBy = "send_by"
            case pickBy = "pick_by"
            case checkinHealth = "checkin_health"
            case checkoutHealth = "checkout_health"
            case reason
            case checkinNotes = "checkin_notes"
            case checkoutNotes = "checkout_notes"
            case date
            case timeIn = "time_in"
            case timeOut = "time_out"
            case morningTemp = "morning_temp"
            case eveningTemp = "evening_temp"
            case status, session
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case sender, picker
        }
}

class StudentAttendanceData: Codable {
    let id: Int?
        let classID: Int?
        let name: String?
        let createdBy: Int?
        let status: String?
        let roleID: Int?
        let email: String?
        let emailVerifiedAt: String?
        let image, address, contactNumber: String?
        let gender: String?
        let islogin: Int?
        let dob: String?
        let active: Int?
        let createdAt: String?
        let updatedAt: String?
        let studentAttendace: StudentAttendance?

        enum CodingKeys: String, CodingKey {
            case id
            case classID = "class_id"
            case name
            case createdBy = "created_by"
            case status
            case roleID = "role_id"
            case email
            case emailVerifiedAt = "email_verified_at"
            case image, address
            case contactNumber = "contact_number"
            case gender, islogin, dob, active
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case studentAttendace = "student_attendace"
        }

        init(id: Int?, classID: Int?, name: String?, createdBy: Int?, status: String?, roleID: Int?, email: String?, emailVerifiedAt: String?, image: String?, address: String?, contactNumber: String?, gender: String?, islogin: Int?, dob: String?, active: Int?, createdAt: String?, updatedAt: String?, studentAttendace: StudentAttendance?) {
            self.id = id
            self.classID = classID
            self.name = name
            self.createdBy = createdBy
            self.status = status
            self.roleID = roleID
            self.email = email
            self.emailVerifiedAt = emailVerifiedAt
            self.image = image
            self.address = address
            self.contactNumber = contactNumber
            self.gender = gender
            self.islogin = islogin
            self.dob = dob
            self.active = active
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.studentAttendace = studentAttendace
        }
}


// MARK: - AnnouncementChildren
struct AllClassesModel: Codable {
    let status: Int?
    let message: String?
    let data: [ClassName]?
}

// MARK: - ClassName
struct ClassName: Codable {
    let id, companyID: Int?
    let name: String?
    let isNapsMeals, ageGroupID: Int?
    let createdAt, updatedAt: String?
    
    var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "company_id"
        case name
        case isNapsMeals = "is_naps_meals"
        case ageGroupID = "age_group_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isSelected
    }
}

//MARK: Payments
struct PaymentsModel: Codable {
    let status: Int?
    let message: String?
    let data: [PaymentsData]?
}

struct PaymentModel: Codable {
    let status: Int?
    let message: String?
    let data: PaymentsData?
}

struct PaymentsData: Codable {
    let id, studentID: Int?
        let amount, invoiceStartDate, invoiceEndDate, invoicePaymentDue: String?
        let status, taxPercent: String?
        let note, statusTime: String?
        let createdAt, updatedAt: String?
        let deletedAt, paidStatusTime: String?
        let tax: String?
        let invoiceItems: [InvoiceItem]?
        let student: ChildInfoModel?

        enum CodingKeys: String, CodingKey {
            case id
            case studentID = "student_id"
            case amount
            case invoiceStartDate = "invoice_start_date"
            case invoiceEndDate = "invoice_end_date"
            case invoicePaymentDue = "invoice_payment_due"
            case status
            case taxPercent = "tax_percent"
            case note
            case statusTime = "status_time"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case paidStatusTime = "paid_status_time"
            case tax
            case invoiceItems = "invoice_items"
            case student
        }
}

// MARK: - InvoiceItem
struct InvoiceItem: Codable {
    let id, invoiceID: Int?
        let itemName: String?
        let itemQty, itemCost: String?
        let createdAt, updatedAt: String?
        let deletedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case invoiceID = "invoice_id"
            case itemName = "item_name"
            case itemQty = "item_qty"
            case itemCost = "item_cost"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
        }
    }

struct ChildInfoModel: Codable {
    let id, classID: Int?
    let name: String?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email, emailVerifiedAt: String?
    let image: String?
    let address, contactNumber: String?
    let gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case classID = "class_id"
        case name
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Like
struct LikeModel: Codable {
    let status: Int?
    let message: String?
    let data: Int?
}

// MARK: - Comments
struct CommentsModel: Codable {
    let status: Int?
    let message: String?
    let data: CommentsData?
}

// MARK: - DataClass
struct CommentsData: Codable {
    let id, userID, classID, companyID: Int?
    let teacherID: Int?
    let skillID: Int?
    let domainID, ageGroupID, isApproved: Int?
    let postDate: String?
    let title: String?
    let isDashboard: Int?
    let postContent, postType, createdAt, updatedAt: String?
    let comments: [Comment]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case classID = "class_id"
        case companyID = "company_id"
        case teacherID = "teacher_id"
        case skillID = "skill_id"
        case domainID = "domain_id"
        case ageGroupID = "age_group_id"
        case isApproved = "is_approved"
        case postDate = "post_date"
        case title
        case isDashboard = "is_dashboard"
        case postContent = "post_content"
        case postType = "post_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments
    }
}

// MARK: - Comment
struct Comment: Codable {
    let id, userID, portfolioID: Int?
    let comment, createdAt, updatedAt: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case portfolioID = "portfolio_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let classID: Int?
    let name: String?
    let quickbooksID: String?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt: String?
    let image, address, contactNumber, gender: String?
    let islogin: Int?
    let dob: String?
    let active: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case classID = "class_id"
        case name
        case quickbooksID = "quickbooks_id"
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, address
        case contactNumber = "contact_number"
        case gender, islogin, dob, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

struct AllCData: Codable {
    let status: Int?
    let message: String?
    let data: [AllCDataData]?
}

// MARK: - Datum
struct AllCDataData: Codable {
    let email: JSONNull?
    let id: Int?
    let dob: String?
    let studentProfile: StudentProfileDD?
    let name, image: String?

    enum CodingKeys: String, CodingKey {
        case email, id, dob
        case studentProfile = "student_profile"
        case name, image
    }
}

// MARK: - StudentProfile
struct StudentProfileDD: Codable {
    let id: KeyValue?
    let birthCertificate, className: JSONNull?
    let rotationID, permitPermission: Int?
    let createdAt: JSONNull?
    let userID, classStatus: Int?
    let enrollmentDate, updatedAt, classID: String?
    let status: Int?
    let endingDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case birthCertificate = "birth_certificate"
        case className = "class_name"
        case rotationID = "rotation_id"
        case permitPermission = "permit_permission"
        case createdAt = "created_at"
        case userID = "user_id"
        case classStatus = "class_status"
        case enrollmentDate = "enrollment_date"
        case updatedAt = "updated_at"
        case classID = "class_id"
        case status
        case endingDate = "ending_date"
    }
    
    enum KeyValue: Codable {
        case int(Int)
        case string(String)
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            }
            else if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            }
             else {
                throw DecodingError.typeMismatch(KeyValue.self, .init(codingPath: decoder.codingPath, debugDescription: "Expected to decode Int or String"))
            }
        }
    }
}
