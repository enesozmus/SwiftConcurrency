//
//  Concurrency1.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 21.06.2024.
//

import SwiftUI

struct Concurrency1: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Concurrency1()
}

/*
    🔴 Concurrency
        ❗️ Perform asynchronous operations.

        - Swift has built-in support for writing asynchronous and parallel code in a structured way.
        - Asynchronous code can be suspended and resumed later, although only one piece of the program executes at a time.
        - Parallel code means multiple pieces of code run simultaneously — for example, a computer with a four-core processor can run four pieces of code at the same time, with each core carrying out one of the tasks.
        - A program that uses parallel and asynchronous code carries out multiple operations at a time, and it suspends operations that are waiting for an external system.
        ✅ Suspending and resuming code in your program lets it continue to make progress on short-term operations like updating its UI while continuing to work on long-running operations like fetching data over the network or parsing files.
        ❗️ This is done in two steps: marking async functions with the new async keyword, then calling them using the await keyword, similar to other languages such as C# and JavaScript.
 
    🔴 async | Defining and Calling Asynchronous Functions
        ❓ What is async?
        - Async stands for asynchronous and can be seen as a method attribute making it clear that a method performs asynchronous work.
        - An asynchronous function or asynchronous method is a special kind of function or method that can be suspended while it’s partway through execution.
        - This is in contrast to ordinary, synchronous functions and methods, which either run to completion, throw an error, or never return.
        - An asynchronous function or method still does one of those three things, but it can also pause in the middle when it’s waiting for something.

            func listPhotos(inGallery name: String) async -> [String] {
            }
            func fetchImages() async throws -> [UIImage] {
            }

    🔴 await | Execution suspends
        ❓ What is await?
        - Await is the keyword to be used for calling async methods.
        - When calling an asynchronous method, execution suspends until that method returns.
        - Inside an asynchronous method, the flow of execution is suspended only when you call another asynchronous method.
        - Marking all of the possible suspension points in your code helps make concurrent code easier to read and understand.
        - You write "await" in front of the call to mark the possible suspension point.
        ✅ This is like writing try when calling a throwing function, to mark the possible change to the program’s flow if there’s an error.
 
             do {
                ❗️ Using the await keyword, we tell our program to await a result from the fetchImages method and only continue after a result arrived.
                 
                let images = try await fetchImages()
                 print("Fetched \(images.count) images.")
             } catch {
                 print("Fetching images failed with error \(error)")
             }
 
    🟢 For example, the code below fetches the names of all the pictures in a gallery and then shows the first picture:

        ❗️ Because the listPhotos(inGallery:) and downloadPhoto(named:) functions both need to make network requests, they could take a relatively long time to complete.
        ❗️ The possible suspension points in your code marked with await indicate that the current piece of code might pause execution while waiting for the asynchronous function or method to return. (This is also called yielding the thread because, behind the scenes, Swift suspends the execution of your code on the current thread and runs some other code on that thread instead.)
            
            ...
             let photoNames = await listPhotos(inGallery: "Summer Vacation")
             let sortedNames = photoNames.sorted()
             let name = sortedNames[0]
             let photo = await downloadPhoto(named: name)
             show(photo)
            ...
 
         1️⃣ The code starts running from the first line and runs up to the first await. It calls the listPhotos(inGallery:) function and suspends execution while it waits for that function to return.
         2️⃣ While this code’s execution is suspended, some other concurrent code in the same program runs. For example, maybe a long-running background task continues updating a list of new photo galleries. That code also runs until the next suspension point, marked by await, or until it completes.
         3️⃣ After listPhotos(inGallery:) returns, this code continues execution starting at that point. It assigns the value that was returned to photoNames.
         4️⃣ The lines that define sortedNames and name are regular, synchronous code. Because nothing is marked await on these lines, there aren’t any possible suspension points.
         5️⃣ The next await marks the call to the downloadPhoto(named:) function. This code pauses execution again until that function returns, giving other concurrent code an opportunity to run.
         6️⃣ After downloadPhoto(named:) returns, its return value is assigned to photo and then passed as an argument when calling show(_:).
 
    🔴 How async replaces closure completion callbacks
         - Async methods replace the often seen closure completion callbacks.
         - Completion callbacks were common in Swift to return from an asynchronous task, often combined with a Result type parameter. The above method would have been written as followed:

         func fetchImages(completion: (Result<[UIImage], Error>) -> Void) {
         }

         Defining a method using a completion closure is still possible in Swift today, but it has a few downsides that are solved by using async instead:

             1️⃣ Closures are harder to read.
             2️⃣ You have to make sure yourself to call the completion closure in each possible method exit. Not doing so will possibly result in an app waiting for a result endlessly.
             3️⃣ Retain cycles need to be avoided using weak references.
             4️⃣ Implementors need to switch over the result to get the outcome.
             5️⃣ It’s not possible to use try catch statements from the implementation level.

         Note: With async/await now in Swift itself, the Result type introduced in Swift 5.0 becomes much less important as one of its primary benefits was improving completion handlers.
 */
