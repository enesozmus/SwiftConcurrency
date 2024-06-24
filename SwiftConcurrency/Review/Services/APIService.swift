//
//  APIService.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 23.06.2024.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response.", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}


// MARK: A Reusable API Service
struct APIService {
    let urlString: String
    
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        do {
            /*
                 func data(
                     from url: URL,
                     delegate: (any URLSessionTaskDelegate)? = nil
                 ) async throws -> (Data, URLResponse)
             */
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError("APIService -> \(error.localizedDescription)")
            }
        } catch {
            throw APIError.dataTaskError("APIService -> \(error.localizedDescription)")
        }
    }
    
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                               completionHandler: @escaping (Result<T, APIError>) -> Void) {
        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                completionHandler(.failure(.invalidResponseStatus))
                return
            }
            guard
                error == nil
            else {
                completionHandler(.failure(.dataTaskError(error!.localizedDescription)))
                return
            }
            guard
                let data = data
            else {
                completionHandler(.failure(.corruptData))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingError("APIService -> \(error.localizedDescription)")))
            }
        }
        .resume()
    }
    
    
    
    /*
        As you are likely to see still, for quite a while, the older method of dealing with concurrency, we're going to start there.
        This will require using what is known as "-a completion handler-", and eventually we're going to be using "-a result type-" as our completion handler's argument.
        Let's start easy now and build on this concept.
        The reason we need "-a completion handler-" is because we have no idea how long it's going to take for that network call to fetch that data.
        And since our code is inherently synchronous, it would move on to the next line before we received our data.

        And "-the completion handler-" is just a closure that we can pass in as an argument so that it will get executed when that data has been retrieved, and we can give that closure a name.
        And typically people call it something like completion or completion handler.

        So when this function has completed and we'll either have successfully retrieved our JSON and decoded it, or an error will have been produced.
     
            -> A Result Type is simply an enum with two cases, either a success case with an associated value and that associated value will be in our case, the array of users, the successful completion or a failure case where the result is an error type.
            -> A value that represents either a success or a failure, including an associated value in each case.

        There will be another issue, however, as we'll be fetching that from a server and it's going to take some time the function itself will escape the scope before we're done.
        So we'll need to specify that this "-completion handler-" is going to escape.
        So we do that by marking the completion function as @escaping.
        
        ✅ Well, now we can get to work.
     */
    func getUsers(completionHandler: @escaping (Result<[UserModel], APIError>) -> Void) {
        
        // First, we'll need to create a URL from our string, and we can use a guard check for this.
        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(.invalidURL))
            return
        }
        // Next, we'll use the .dataTask(with: completionHandler:) function of URLSession class.
        /*
            🔴 Creates a task that retrieves the contents of the specified URL, then calls a handler upon completion.
               After you create the task, you must start it by calling its resume() method.

         
             func dataTask(
                 with url: URL,
                 completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
             ) -> URLSessionDataTask
        */
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // So now we can check on those three optional items that we get back.
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                completionHandler(.failure(.invalidResponseStatus))
                return
            }
            guard
                error == nil
            else {
                completionHandler(.failure(.dataTaskError(error!.localizedDescription)))
                return
            }
            guard
                let data = data
            else {
                completionHandler(.failure(.corruptData))
                return
            }
            
            // Well, now that we've got the data, we can try to decode it.
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([UserModel].self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingError("APIService -> \(error.localizedDescription)")))
            }
        }
        .resume()
        // The most important thing that we have to do before we forget, however, is to make sure that this task gets initiated.
        // So we'll also need to call resume() because it's initially in a suspended state.
    }
}
