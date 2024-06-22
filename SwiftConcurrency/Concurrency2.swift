//
//  Concurrency2.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 21.06.2024.
//

import SwiftUI

struct Concurrency2: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Concurrency2()
}

/*
     🔴 Async await replaces callbacks with completion closures
         - The introduction of async await in Swift 5.5 replaced completion closures in asynchronous functions.
         - Before Swift concurrency, callbacks were necessary to resume execution when asynchronous functions finished.
     
     🟢 If you’ve worked with asynchronous functions before async await, chances are your code resembled something like this:
     
         func fetchImageData(completion: @escaping (Result<Data, Error>)) {
 
                let url = URL(string: "https://images.dog.ceo/breeds/mountain-swiss/n02107574_1387.jpg")!
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        }
     
     ❗️ This approach presents several drawbacks:
     
     1️⃣ Closures are hard to read, making it more difficult to follow the execution path than async await functions.
     2️⃣ It’s easy to make mistakes. In intricate functions, it’s easy to forget to invoke the completion closure before returning or to call it multiple times.
     3️⃣ You might create retain cycles. Referencing the self instance of an object in a closure requires weak self references.
     4️⃣ It’s not possible to use Swift’s error handling. Handling errors via the Result type requires switching over its cases. Before the Result type was available, developers used tuples and optionals, exacerbating these issues.
     5️⃣ Sequencing asynchronous function calls is more intricate. This often results in a problem known as the pyramid of doom, sometimes also called callback hell.
 */

/*
     🔴 Introduction
         - Async functions can be suspended and resumed later, allowing your app to keep its UI responsive while working on long tasks, like making REST API calls.
         - One of the most common examples of asynchronous code in Swift and iOS is downloading data with URLSession. Compared to the speed of code running on a device, transferring data over the internet is a slow process, which requires your function to wait until the download is complete.

     🔴 Why do we need asynchronous functions in Swift and iOS apps?
         - Code that takes too long to execute can negatively affect your app’s performance.
         - Code can take a long time to execute for two reasons:

             1️⃣ It must complete a slow process, such as fetching data from a large database, collecting data from a device sensor, or transmitting data over a network connection.
             2️⃣ It needs to run a computationally expensive algorithm, for example, a sorting algorithm on a large set of data, a search algorithm like A*, or a decision algorithm like Minimax.

         - In addition to that when learning Swift programming, all your programs run from start to finish without interruption. Even when you split an extensive program using structures and classes, its code runs sequentially.
         - However, interactive iOS apps do not have a clear “start” and “end”.
         - When running, an iOS app idly waits for input, such as the user tapping a button or data arriving from the network. When such an input arrives, it triggers an event in the app that causes your code to run. The user interface must be updated as the code changes the app’s internal state.
         - The cycle runs so swiftly that the app appears to respond instantly to user input. However, this system has a limitation: if some code takes too long to execute, it delays the cycle’s subsequent UI update and input phases. Consequently, your app may feel sluggish, freeze briefly, and lose input. This is precisely why we need Swift concurrency and asynchronous functions.

     🔴 What is async and await in Swift?
         Async/await is a mechanism used to create and execute asynchronous functions in Swift.
         Using async await in Swift is as simple as marking asynchronous functions with the async keyword and calling them using the await keyword.
         
         1️⃣ "async" indicates that a function or method is asynchronous and can pause its execution to wait for the completion of another process.
         2️⃣ "await" marks a suspension point in your code where execution may wait for the result of an async function or method.

     🔴 How to write an async function in Swift
         - To declare an asynchronous function in Swift, write the "async" keyword after the function name and before its return type.
         - An asynchronous function can also throw errors like a normal function. It is marked with the "async throws" keywords in such cases.

             func fetchImageData() async throws -> Data {
             }

        ❗️ Whenever one of your functions calls another asynchronous method, it must also be declared as async.
 */


/*
     🔴 Blocking the main run loop for too long makes your app unresponsive
         - Modern operating systems, like iOS, utilize complex techniques for time-sharing, multitasking, and threading), enabling the execution of code concurrently on a CPU that can only run instructions sequentially.
         ❗️ Asynchronous functions can perform long tasks without blocking the app’s main run loop.
         - When you call an asynchronous function, your code gets suspended, leaving the app’s main run loop free.
         - Meanwhile, the work performed by the asynchronous function runs “in the background”.
         - What matters is that the code running in the background can take as much time as it needs without impacting the app’s main run loop.
         - When it finishes and returns a result, the system resumes your code where it left off and continues executing it.

     🔴 Cooperative Thread Pool
         - The Swift language introduces the Cooperative Thread Pool, which allows you to run concurrent parts of your apps.
         - The number of threads in the pool is limited to your CPU’s cores, which prevents thread explosion.
         ✅ So, we have two crucial places where Swift can run our code: Main Thread and Cooperative Thread Pool.
         - We should use the main thread to update the UI of our apps and we should avoid blocking it by running heavy work on it.
         - That’s why we have the Cooperative Thread Pool to run heavy jobs.

     ⚠️ Warnings
         1️⃣ If you add an "async" keyword to your function, it can be called on a background thread even if you start the function from the Main Thread.

         2️⃣ If you run a code from "Task{}", you can’t make any assumptions about the thread. It could be dispatched on any thread (unless it is started from the Main Actor).

         3️⃣ If you call "await" within an asynchronous function, it creates a suspension point that may switch execution to any pending code, even to the same function if it was called multiple times.

         4️⃣ If your asynchronous function resumes after await, the thread is not guaranteed to be the same as before await (unless you use @MainActor).

         5️⃣ If you add @MainActor attribute to a function, it is not the same as wrapping the whole method in DispatchQueue.main.async.
 */
