//
//  PlacePhotoView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 26/01/25.
//

import SwiftUI

struct PlacePhotoView: View {
    @State private var imageUrl: String?

    var placeName: String

    var body: some View {
        VStack {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                ProgressView()
                    .onAppear(perform: fetchPhoto)
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func fetchPhoto() {
        let formattedName = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=\(formattedName)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let query = json["query"] as? [String: Any],
               let pages = query["pages"] as? [String: Any],
               let page = pages.values.first as? [String: Any],
               let original = page["original"] as? [String: Any],
               let source = original["source"] as? String {
                DispatchQueue.main.async {
                    self.imageUrl = source
                }
            }
        }.resume()
    }
}
