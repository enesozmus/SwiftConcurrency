//
//  UsersListViewModel.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var users: [UserModel] = []
    @Published var usersAndPosts: [UserAndPostsModel] = []
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    
    
    @MainActor
    func fetchUsersAndPosts() async {
        let apiService1 = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiService2 = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        isLoading.toggle()
        defer { isLoading.toggle() }
        do {
            async let users: [UserModel] = try await apiService1.getJSON()
            async let posts: [PostModel] = try await apiService2.getJSON()
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            for user in fetchedUsers {
                let userPosts =  fetchedPosts.filter {$0.userId == user.id}
                let newUserAndPosts = UserAndPostsModel(user: user, posts: userPosts)
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            self.showAlert = true
            self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }
    }
    
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading.toggle()
        defer { isLoading.toggle() }
        do {
            users = try await apiService.getJSON()
        } catch {
            self.showAlert = true
            self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }
    }
    
    /*
    func fetchUsers() {
        let apiService: APIService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading.toggle()
        //DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
            apiService.getJSON { (result: Result<[UserModel], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                    }
                }
            }
        //}
    }
    */
}


// MARK: Extension for Mock Data (Seed Data)
//extension UsersListViewModel {
//    convenience init(forPreview: Bool = false) {
//        self.init()
//        if forPreview {
//            self.users = UserModel.mockUsers
//        }
//    }
//}
extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.usersAndPosts = UserAndPostsModel.mockUsersAndPosts
        }
    }
}
