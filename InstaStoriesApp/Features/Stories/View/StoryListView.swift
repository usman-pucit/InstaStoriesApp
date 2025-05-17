//
//  StoryListView.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import SwiftUI

struct StoryListView: View {
    @State private var viewModel = StoryListViewModel()
    @State private var reloadTrigger = UUID()
    
    var body: some View {
        NavigationStack {
            ZStack {
                contentView
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Stories")
        }
        .background(Color(.systemBackground))
        .task(id: reloadTrigger) {
            await viewModel.fetchStories()
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            LoadingView()
        case .error(let error):
            errorView(with: error)
        case .result(let stories):
            StoriesView(stories: stories, viewModel: viewModel)
        case .empty:
            emptyView
        }
    }
    
    private var emptyView: some View {
        GenericErrorView(errorMessage: "No stories available") {
            reloadTrigger = UUID()
        }
    }
    
    private func errorView(with error: Error) -> some View {
        GenericErrorView(errorMessage: error.localizedDescription) {
            reloadTrigger = UUID()
        }
    }
}


// MARK: - Private Views
private struct StoriesView: View {
    private let stories: [UI.Story.User]
    @State private var viewModel: StoryListViewModel
    
    init(
        stories: [UI.Story.User],
        viewModel: StoryListViewModel
    ) {
        self.stories = stories
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryCell(story: story, isSeen:  viewModel.seenStories.contains(story.id))
                        .onAppear {
                            Task {
                                await viewModel.loadMoreItemsIfNeeded(currentItem: story)
                            }
                        }
                        .onTapGesture {
                            viewModel.markStoryAsSeen(id: story.id)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Private Views
private struct StoryCell: View {
    let story: UI.Story.User
    let isSeen: Bool
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: story.profilePictureUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        isSeen ? Color.gray : Color.blue,
                        lineWidth: 2
                    )
            )
            
            Text(story.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}

#Preview {
    StoryListView()
}
