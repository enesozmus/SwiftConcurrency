//
//  PostsListViewModel.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    var userId: Int?
    
    
    @MainActor
    func fetchPosts() async {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            defer { isLoading.toggle() }
            do {
                posts = try await apiService.getJSON()
            } catch {
                self.showAlert = true
                self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
            }
        }
    }
    
    /*
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            apiService.getJSON { (result: Result<[PostModel], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                    }
                }
            }
        }
    }
    */
}


// MARK: Extension for Mock Data (Seed Data)
//extension PostsListViewModel {
//    convenience init(forPreview: Bool = false) {
//        self.init()
//        if forPreview {
//            self.posts = PostModel.mockSingleUsersPostsArray
//        }
//    }
//}
extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = PostModel.mockSingleUsersPostsArray
        }
    }
}
