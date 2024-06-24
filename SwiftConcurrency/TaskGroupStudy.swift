//
//  TaskGroupStudy.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 24.06.2024.
//

import SwiftUI

class TaskGroupStudyDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/200/300")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/200/300")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/200/300")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/200/300")
        
        let (image1, image2, image3, image4) = try await ( fetchImage1,  fetchImage2,  fetchImage3,  fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300",
            "https://picsum.photos/200/300",
        ]
        /*
             🔴 TaskGroup
                - A group that contains dynamically created child tasks.
                - To create a task group, call the withTaskGroup(of:returning:body:) method.
         */
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupStudyViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    let manager = TaskGroupStudyDataManager()

    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupStudy: View {

    @StateObject private var viewModel = TaskGroupStudyViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                    }
                }
            }
            .navigationTitle("Task Group 🥳")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupStudy()
}
