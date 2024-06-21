//
//  ErrorHandling2.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 20.06.2024.
//

import SwiftUI

// do-catch
// try
// throws


// MARK: DataManager
class DoCatchTryThrowsDataManager {
    
    let isActive: Bool = true //false
    
    // ... 🔵
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    // ... 🔵
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    // ... 🔵
    func getTitle3() throws -> String {
        //        if isActive {
        //            return "NEW TEXT!"
        //        } else {
        throw URLError(.badServerResponse)
        //        }
    }
    // ... 🔵
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}


// MARK: ViewModel
class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
        // ... 🔵
        /*
         let returnedValue: (title: String?, error: (any Error)?) = manager.getTitle()
         
         if let newTitle: String = returnedValue.title {
            self.text = newTitle
         } else if let error = returnedValue.error {
            self.text = error.localizedDescription
         }
         */
        // ... 🔵
        /*
        let result: Result<String, any Error> = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        */
        // ... 🔵
        do {
            //            let newTitle = try manager.getTitle3()
            //            self.text = newTitle
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}


// MARK: View
struct ErrorHandling2: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}


// MARK: Preview
#Preview {
    ErrorHandling2()
}
