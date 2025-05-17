//
//  StoryListUseCase.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

// Define a protocol for the use case
protocol StoryListUseCaseType {
    func fetchStories() async throws -> [Domain.Story.Response]
}

// MARK: - UseCase
final class StoryListUseCase {
    private let repository: StoryListRepositoryType
    
    init(
        repository: StoryListRepositoryType = StoryListRepository()
    ) {
        self.repository = repository
    }
}

extension StoryListUseCase: StoryListUseCaseType {
    func fetchStories() async throws -> [Domain.Story.Response] {
        try await repository.fetchStories()
    }
}
   
