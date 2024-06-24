//
//  PostsListView.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import SwiftUI

struct PostsListView: View {
    
#if DEBUG
    // remove the forPreview argument or set it to false before uploading to App Store
    @StateObject private var viewModel = PostsListViewModel(forPreview: true)
#else
    @StateObject private var viewModel = PostsListViewModel()
#endif
    var posts: [PostModel]
    //var userId: Int?
    
    var body: some View {
        List {
            //ForEach(viewModel.posts) { post in
            ForEach(posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .overlay(content: {
            if viewModel.isLoading {
                ProgressView()
            }
        })
        .alert("Application Error", isPresented: $viewModel.showAlert, actions: {
            Button("OK") {}
        }, message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        })
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        //        .task {
        //            viewModel.userId = userId
        //            await viewModel.fetchPosts()
        //        }
        //        .onAppear {
        //            viewModel.userId = userId
        //            viewModel.fetchPosts()
        //        }
    }
}

#Preview {
    //PostsListView(userId: 1)
    NavigationStack {
        PostsListView(posts: PostModel.mockSingleUsersPostsArray)
    }
}
