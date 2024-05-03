//
//  UserdefaultsExt.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 15/10/23.
//

import Foundation

// MARK: - UserDefaults extensions

public extension UserDefaults {

    /// Set Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    func set<T: Codable>(object: T, forKey: String) throws {

        let jsonData = try JSONEncoder().encode(object)

        set(jsonData, forKey: forKey)
    }

    /// Get Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {

        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }

        return try JSONDecoder().decode(objectType, from: result)
    }
}
