//
//  Stories+API.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

extension API.Story {
    struct Response: Decodable {
        let pages: [Page]
    }
}

extension API.Story.Response {
    struct Page: Decodable {
        let users: [User]
    }
}

extension API.Story.Response.Page {
    struct User: Decodable {
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
