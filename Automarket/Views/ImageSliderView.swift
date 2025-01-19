//
//  ImageSliderView.swift
//  Automarket
//
//  Created by Oleg Granchenko on 31.12.2024.
//

import SwiftUI

struct ImageSliderView: View {
    let images: [URL]

    var body: some View {
        TabView {
            ForEach(images.indices, id: \.self) { index in
                let image = images[index]
                AsyncImage(url: image) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let imageUrls = [
            ImageURL(url: "https://loremflickr.com/g/480/640/ford"),
            ImageURL(url: "https://loremflickr.com/g/1200/1600/ford"),
            ImageURL(url: "https://loremflickr.com/g/640/480/ford")
        ]

        // Convert ImageURL objects to URL objects
        let urls = imageUrls.compactMap { URL(string: $0.url) }

        // Use the ImageSliderView with an array of URL objects
        ImageSliderView(images: urls)
            .frame(height: 200)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
