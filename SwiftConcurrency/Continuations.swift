//
//  Continuations.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 25.06.2024.
//

import SwiftUI

class ContinuationsNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async -> UIImage {
        await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}


class ContinuationsViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = ContinuationsNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200/300") else { return }
        
        do {
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() async {
        self.image = await networkManager.getHeartImageFromDatabase()
    }
}


struct Continuations: View {
    
    @StateObject private var viewModel = ContinuationsViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
            }
        }
        .task {
            //await viewModel.getImage()
            //await viewModel.getHeartImage()
        }
    }
}

#Preview {
    Continuations()
}


/*
     🔴 Continuations for interfacing async tasks with synchronous code
         - SE-0300 introduced new functions to help us adapt older, completion handler-style APIs to modern async code.

         - "Continuations" are a super-handy addition to the Swift language that allows us to convert code that is not created for an asynchronous context into code that can easily be integrated into our async/await methods.

         - Older Swift code uses completion handlers for notifying us when some work has completed, and sooner or later you’re going to have to use it from an async function – either because you’re using a library someone else created.

         - Swift uses continuations to solve this problem, allowing us to create a bridge between older functions with completion handlers and newer async code.

         - For example, this function returns its values asynchronously using a completion handler:

             func fetchLatestNews(completion: @escaping ([String]) -> Void) {
                 DispatchQueue.main.async {
                     completion(["Swift 5.5 release", "Apple acquires Apollo"])
                 }
             }

         - If you wanted to use that using async/await you might be able to rewrite the function, but there are various reasons why that might not be possible – it might come from an external library, for example.

         - Continuations allow us to create a shim between the completion handler and async functions so that we wrap up the older code in a more modern API. For example, the withCheckedContinuation() function creates a new continuation that can run whatever code you want, then call resume(returning:) to send a value back whenever you’re ready – even if that’s part of a completion handler closure.

         - So, we could make a second fetchLatestNews() function that is async, wrapping around the older completion handler function:

             func fetchLatestNews() async -> [String] {
                 await withCheckedContinuation { continuation in
                     fetchLatestNews { items in
                         continuation.resume(returning: items)
                     }
                 }
             }
             func printNews() async {
                 let items = await fetchLatestNews()

                 for item in items {
                     print(item)
                 }
             }

         The term “checked” continuation means that Swift is performing runtime checks on our behalf: are we calling resume() once and only once? This is important, because if you never resume the continuation then you will leak resources, but if you call it twice then you’re likely to hit problems.

         Important: To be crystal clear, you must resume your continuation exactly once.

         As there is a runtime performance cost of checking your continuations, Swift also provides a withUnsafeContinuation() function that works in exactly the same way except does not perform runtime checks on your behalf. This means Swift won’t warn you if you forget to resume the continuation, and if you call it twice then the behavior is undefined.

         Because these two functions are called in the same way, you can switch between them easily. So, it seems likely people will use withCheckedContinuation() while writing their functions so Swift will emit warnings and even trigger crashes if the continuations are used incorrectly, but some may then switch over to withUnsafeContinuation() as they prepare to ship if they are affected by the runtime performance cost of checked continuations.
 */


/*
     struct Message: Decodable, Identifiable {
         let id: Int
         let from: String
         let message: String
     }

     func fetchMessages(completion: @escaping ([Message]) -> Void) {
         let url = URL(string: "https://hws.dev/user-messages.json")!

         URLSession.shared.dataTask(with: url) { data, response, error in
             if let data = data {
                 if let messages = try? JSONDecoder().decode([Message].self, from: data) {
                     completion(messages)
                     return
                 }
             }

             completion([])
         }
         .resume()
     }

     func fetchMessages() async -> [Message] {
         await withCheckedContinuation { continuation in
             fetchMessages { messages in
                 continuation.resume(returning: messages)
             }
         }
     }

     let messages = await fetchMessages()
     print("Downloaded \(messages.count) messages.")
 */
