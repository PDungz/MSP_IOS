//
//  User.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String?
    let email: String?
    let username: String?
    let fullName: String?
    let avatar: String?
    let createdAt: String?

    static let mockUser = User(
        id: "123456789",
        email: "phungvandung@gmail.com",
        username: "phungvandung",
        fullName: "Phùng Văn Dũng",
        avatar: "https://via.placeholder.com/150",
        createdAt: "2021-09-25T14:30:00Z"
    )
}
