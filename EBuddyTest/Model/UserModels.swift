//
//  UserModels.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import Foundation

struct UsersModel {
    var uid: String?
    var email: String?
    var phoneNumber: String?
    var gender: GenderEnum?
    var isActive: Bool?
    var photoProfileUrl: String?
    var rating: Double?
    var totalRating: Int?
    var pricePerHour: Double?
    var instagramUrl: String?
    var lastActive: Double?

    static func createObject(_ data: [String: Any]) -> UsersModel {
        var model = UsersModel()
        model.uid = data["uid"] as? String
        model.email = data["email"] as? String
        model.phoneNumber = data["phoneNumber"] as? String
        model.gender = GenderEnum(rawValue: data["gender"] as? Int ?? 0)
        model.isActive = data["isActive"] as? Bool
        model.photoProfileUrl = data["photoProfileUrl"] as? String
        model.rating = data["rating"] as? Double
        model.totalRating = data["totalRating"] as? Int
        model.pricePerHour = data["pricePerHour"] as? Double
        model.instagramUrl = data["instagramUrl"] as? String
        model.lastActive = data["lastActive"] as? Double

        return model
    }
}
