//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 24.06.2024.
//

import SwiftUI

struct AsyncLet: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200/300")!
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                    }
                }
            }
            .navigationTitle("Async Let 🎡")
            .onAppear {
                Task {
                    do {
                        async let fetchImage = fetchImage()
                        async let fetchTitle = fetchTitle()
                        let (image, title) = try await (fetchImage, fetchTitle)
                        self.images.append(image)
                        
                        /*
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        let (image1, image2, image3, image4) = try await ( fetchImage1,  fetchImage2,  fetchImage3,  fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        */
                        
                        /*
                        let image1 = try await fetchImage()
                        self.images.append(image1)
                        
                        let image2 = try await fetchImage()
                        self.images.append(image2)
                        
                        let image3 = try await fetchImage()
                        self.images.append(image3)
                        
                        let image4 = try await fetchImage()
                        self.images.append(image4)
                        */
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
    
    func fetchImage() async throws -> UIImage {
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

#Preview {
    AsyncLet()
}
