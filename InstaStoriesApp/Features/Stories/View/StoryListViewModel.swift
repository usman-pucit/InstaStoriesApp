//
//  StoryListViewModel.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

// Define a protocol for the view model
protocol StoryListViewModelType {
    func fetchStories() async
}

// Mark: - ViewModel
@Observable
final class StoryListViewModel {
    enum State {
        case idle
        case loading
        case result([UI.Story.User])
        case empty
        case error(Error)
    }
    
    private(set) var viewState: State = .idle
        
    @ObservationIgnored
    private let useCase: StoryListUseCaseType
    
    init(
        useCase: StoryListUseCaseType = StoryListUseCase()
    ) {
        self.useCase = useCase
    }
}

extension StoryListViewModel: StoryListViewModelType {
    @MainActor
    func fetchStories() async {
        viewState = .loading
        
        do {
            let stories = try await useCase.fetchStories()
            let users = stories.flatMap { $0.users }
            let normalizedUsers = users.map { $0.normalize()} // Normalize the response
            viewState = .result(normalizedUsers)
        } catch {
            viewState = .error(error)
        }
    }
}
