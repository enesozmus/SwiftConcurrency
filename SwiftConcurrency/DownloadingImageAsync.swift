//
//  DownloadingImageAsync.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 21.06.2024.
//

import Combine
import SwiftUI


// MARK: DataManager/Service
class DownloadingImageAsyncDataManager {
    
    let url: URL? = URL(string: "https://picsum.photos/200/300")
    
    
    // ... 🔵
    //    func downloadImageWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
    //        guard let url = self.url else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            guard
    //                let data = data,
    //                let image = UIImage(data: data),
    //                let response = response as? HTTPURLResponse,
    //                response.statusCode >= 200 && response.statusCode < 300 else {
    //                completionHandler(nil, error)
    //                return
    //            }
    //            completionHandler(image, nil)
    //        }
    //        .resume()
    //    }
    
    
    // ... 🔵
    //    func downloadImageWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
    //        guard let url = self.url else { return }
    //        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
    //            let image = self?.handleResponse(data: data, response: response)
    //            completionHandler(image, nil)
    //        }
    //        .resume()
    //    }
    
    
    // ... 🔵
    //    func downloadImageWithCombine() -> AnyPublisher<UIImage?, Error> {
    //        URLSession.shared.dataTaskPublisher(for: url!)
    //            .map(handleResponse)
    //            .mapError( { $0 })
    //            .eraseToAnyPublisher()
    //    }
    
    
    // ... 🔵
    func downloadImageWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url!, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    
    // ... handleResponse
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
}


// MARK: ViewModel
class DownloadingImageAsyncViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let manager = DownloadingImageAsyncDataManager()
    var cancellables = Set<AnyCancellable>()
    
    //func fetchImage() {
    func fetchImage() async {
        
        // ... 🔵
        //self.image = UIImage(systemName: "heart.fill")
        
        
        // ... 🔵
        //        manager.downloadImageWithEscaping { [weak self] image, error in
        //            DispatchQueue.main.async {
        //                if let image = image {
        //                    self?.image = image
        //                }
        //            }
        //        }
        
        
        // ... 🔵
        //        manager.downloadImageWithCombine()
        //            .receive(on: DispatchQueue.main)
        //            .sink { _ in
        //
        //            } receiveValue: { [weak self] image in
        //                //DispatchQueue.main.async {
        //                        self?.image = image
        //                //}
        //            }
        //            .store(in: &cancellables)
        
        
        // ... 🔵
        let image = try? await manager.downloadImageWithAsync()
        await MainActor.run {
            self.image = image
        }
        
    }
}


// MARK: View
struct DownloadingImageAsync: View {
    @StateObject private var viewModel = DownloadingImageAsyncViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    //.resizable()
                    //.scaledToFit()
                    //.frame(width: 200, height: 300)
            }
        }
        .onAppear {
            //viewModel.fetchImage()
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

// MARK: Preview
#Preview {
    DownloadingImageAsync()
}
