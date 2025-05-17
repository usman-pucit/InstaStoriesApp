//
//  Stories+Domain.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

extension Domain.Story {
    struct Response {
        let pages: [Page]
    }
}

extension Domain.Story.Response {
    struct Page {
        let users: [User]
    }
}

extension Domain.Story.Response.Page {
    struct User {
        let id: Int
        let name: String
        let profilePictureUrl: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case profilePictureUrl = "profile_picture_url"
        }
    }
}

// MARK: - Normalizable

extension API.Story.Response: Normalizable {
    typealias Output = Domain.Story.Response
    
    func normalize() -> Output {
        return Output(pages: pages.map { $0.normalize() })
    }
}

extension API.Story.Response.Page: Normalizable {
    typealias Output = Domain.Story.Response.Page
    
    func normalize() -> Output {
        return Output(users: users.map { $0.normalize() })
    }
}

extension API.Story.Response.Page.User: Normalizable {
    typealias Output = Domain.Story.Response.Page.User
    
    func normalize() -> Output {
        return Output(
            id: id,
            name: name,
            profilePictureUrl: profilePictureUrl
        )
    }
}
