//
//  MockData.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import Foundation

extension UserModel {
    static var mockUsers: [UserModel] {
        Bundle.main.decode([UserModel].self, from: "users.json")
    }
    static var mockSingleUser: UserModel {
        Self.mockUsers[0]
    }
}


extension PostModel {
    static var mockPosts: [PostModel] {
        Bundle.main.decode([PostModel].self, from: "posts.json")
    }
    static var mockSinglePost: PostModel {
        Self.mockPosts[0]
    }
    
    static var mockSingleUsersPostsArray: [PostModel] {
        Self.mockPosts.filter { $0.userId == 1}
    }
}


extension UserAndPostsModel {
    static var mockUsersAndPosts: [UserAndPostsModel] {
        var newUsersAndPosts: [UserAndPostsModel] = []
        for user in UserModel.mockUsers {
            let newUserAndPosts = UserAndPostsModel(user: user, posts: PostModel.mockPosts.filter {$0.userId == user.id})
            newUsersAndPosts.append(newUserAndPosts)
        }
        return newUsersAndPosts
    }
}
