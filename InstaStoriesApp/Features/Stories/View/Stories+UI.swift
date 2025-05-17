//
//  Stories+UI.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//


extension UI.Story {
    struct User: Identifiable {
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

extension UI.Story.User: Equatable {
    static func == (lhs: UI.Story.User, rhs: UI.Story.User) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Normalizable

extension Domain.Story.Response.Page.User: Normalizable {
    typealias Output = UI.Story.User
    
    func normalize() -> Output {
        return Output(
            id: id,
            name: name,
            profilePictureUrl: profilePictureUrl
        )
    }
}
