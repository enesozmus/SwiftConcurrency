//
//  UsersListView.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import SwiftUI

struct UsersListView: View {
    
#if DEBUG
    // remove the forPreview argument or set it to false before uploading to App Store
    @StateObject private var viewModel = UsersListViewModel(forPreview: false)
#else
    @StateObject private var viewModel = UsersListViewModel()
#endif
    
    var body: some View {
        NavigationStack {
            List {
                //ForEach(viewModel.users) { user in
                ForEach(viewModel.usersAndPosts) { userAndPosts in
                    NavigationLink {
                        //PostsListView(userId: user.id)
                        PostsListView(posts: userAndPosts.posts)
                    } label: {
                        /*
                        VStack(alignment: .leading)
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        */
                        VStack(alignment: .leading) {
                            HStack {
                                Text(userAndPosts.user.name)
                                    .font(.title)
                                Spacer()
                                Text("(\(userAndPosts.numberOfPosts))")
                            }
                            Text(userAndPosts.user.email)
                                .font(.callout)
                                .foregroundStyle(.secondary)

                        }
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
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                //await viewModel.fetchUsers()
                await viewModel.fetchUsersAndPosts()
            }
            //            .onAppear {
            //                viewModel.fetchUsers()
            //            }
        }
    }
}

#Preview {
    UsersListView()
}
