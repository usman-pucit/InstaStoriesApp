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
    func loadMoreItemsIfNeeded(currentItem: UI.Story.User?) async
    func refresh() async
}

// Mark: - ViewModel
@Observable
final class StoryListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case result([UI.Story.User])
        case empty
        case error(Error)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.empty, .empty):
                return lhs == rhs
            default:
                return true
            }
        }
    }
    
    private(set) var viewState: State = .idle
    
    @ObservationIgnored
    private let useCase: StoryListUseCaseType
    private var currentPage = 0
    private var totalPages = 0
    
    private var canLoadMorePages = true
    private var totalStories: [UI.Story.User] = []
    
    // MARK: - Init
    init(
        useCase: StoryListUseCaseType = StoryListUseCase()
    ) {
        self.useCase = useCase
    }
}

extension StoryListViewModel: StoryListViewModelType {
    func fetchStories() async {
//        viewState = .loading
        
        do {
            let result = try await useCase.fetchStories()
            canLoadMorePages = result.count > currentPage // Check if there are more pages to load
            
            if result.count > currentPage {
                let currentPage = result[currentPage]
                let users = currentPage.users
                let normalizedUsers = users.map { $0.normalize()} // Normalize the response
                self.totalStories += normalizedUsers // Append the new users to the total stories
                
                await MainActor.run {
                    viewState = .result(self.totalStories)
                }
            }
            
        } catch {
            await MainActor.run {
                viewState = .error(error)
            }
        }
    }
    
    func loadMoreItemsIfNeeded(currentItem: UI.Story.User?) async {
        // Implement pagination logic
        guard let item = currentItem,
              item.id == totalStories.last?.id,
              canLoadMorePages
        else {
            return
        }
        
        currentPage += 1
        await fetchStories()
    }
    
    func refresh() async {
        currentPage = 1
        canLoadMorePages = true
        totalStories = []
        await fetchStories()
    }
}
