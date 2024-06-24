//
//  UserAndPostsModel.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 24.06.2024.
//

import Foundation

struct UserAndPostsModel: Identifiable {
    var id = UUID()
    let user: UserModel
    let posts: [PostModel]
    var numberOfPosts: Int {
        posts.count
    }
}
