//
//  StoryListRepository.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

// Define a protocol for the use case
protocol StoryListRepositoryType {
    func fetchStories() async throws -> [Domain.Story.Response]
}

// MARK: - UseCase
final class StoryListRepository {
    private let jsonReader: JSONReaderType
    
    init(
        jsonReader: JSONReaderType = JSONReader()
    ) {
        self.jsonReader = jsonReader
    }
}

extension StoryListRepository: StoryListRepositoryType {
    func fetchStories() async throws -> [Domain.Story.Response] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                do {
                    let stories: [API.Story.Response] = try self.jsonReader.load("story_list")
                    let normalizedStories = stories.map { $0.normalize() } // Normalize the response
                    continuation.resume(returning: normalizedStories)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
