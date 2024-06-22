//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 21.06.2024.
//

import SwiftUI

// MARK: ViewModel
//class AsyncAwaitViewModel: ObservableObject {
//
//    @Published var dataArray: [String] = []
//
//
//    func threadTest1() {
//        // ...number = 1, name = main
//        self.dataArray.append("threadTest1 -> \(Thread.current)")
//    }
//    func threadTest2() {
//        // ...number = 1, name = main
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.dataArray.append("threadTest2 -> \(Thread.current)")
//        }
//    }
//    func threadTest3() {
//        // ...number = changeable, name = (null)
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            self.dataArray.append("threadTest3 -> \(Thread.current)")
//            // ...number = 1, name = main
//            DispatchQueue.main.async {
//                self.dataArray.append("threadTest4 -> \(Thread.current)")
//            }
//        }
//    }
//    func threadTesWithAsync1() async {
//        // ...number = changeable, name = (null)
//        // ⚠️ Class property 'current' is unavailable from asynchronous contexts; Thread.current cannot be used from async contexts.; this is an error in Swift 6
//        self.dataArray.append("threadTesWithAsync1.1 -> \(Thread.current)")
//
//        try? await Task.sleep(for: .seconds(2))
//        // ... 🟣 Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
//        // self.dataArray.append("threadTesWithAsync2 -> \(Thread.current)")
//        await MainActor.run {
//            // ...number = 1, name = main
//            self.dataArray.append("threadTesWithAsync1.2 -> \(Thread.current)")
//        }
//
//        await threadTesWithAsync2()
//
//        self.dataArray.append("threadTesWithAsync1.3 -> \(Thread.current)")
//
//    }
//
//    func threadTesWithAsync2() async {
//
//        try? await Task.sleep(for: .seconds(3))
//
//        // ...number = changeable, name = (null)
//        self.dataArray.append("threadTesWithAsync2.1 -> \(Thread.current)")
//        await MainActor.run {
//            // ...number = 1, name = main
//            self.dataArray.append("threadTesWithAsync2.2 -> \(Thread.current)")
//        }
//
//    }
//}


// MARK: View
struct AsyncAwait: View {
    
    //@StateObject private var viewModel = AsyncAwaitViewModel()
    
    var body: some View {
        List {
            //            ForEach(viewModel.dataArray, id: \.self) { data in
            //                Text(data)
            //            }
        }
        //        .onAppear {
        //            // Üçü de çağrıldığında threadTest2 veya threadTest3 oyundan düşüyor
        //            //            viewModel.threadTest1()
        //            //            viewModel.threadTest2()
        //            //            viewModel.threadTest3()
        //            Task {
        //                await viewModel.threadTesWithAsync1()
        //
        //                let finalText = "FINAL TEXT \(Thread.current)"
        //                viewModel.dataArray.append(finalText)
        //            }
        //        }
    }
}


// MARK: Preview
#Preview {
    AsyncAwait()
}

/*
     - Now we just await "asynchronous tasks" sometimes those "asynchronous tasks" will jump onto background threads sometimes they will not.
     - So just because we are awaiting something doesn't necessarily mean we are going on to a background thread but it can mean that "await" is just a suspension point in the task{}.
     - We are awaiting "the returned result" and and it could be on a different thread it could be on a different actor it might not be. But from our perspective as the developer it does not matter!
     - All we know is that we are waiting for that response and since we're in an asynchronous environment.
     - So it's it's often a good idea to even if you're unsure on you know what thread you're going on to just switch back onto that main thread before updating your UI.
 */
