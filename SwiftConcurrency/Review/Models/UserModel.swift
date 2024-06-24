//
//  UserModel.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/users

struct UserModel: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    //let test: String
}
