//
//  Swift+Html.swift
//  Zamalek FC
//
//  Created by Mohamed Alwakil on 2025-03-19.
//

import Foundation
import SwiftSoup

private func fetchHTML(from url: String) async throws -> Document {
    guard let url = URL(string: url) else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    let (data, _) = try await URLSession.shared.data(from: url)


    //windows-1256
    guard  let html = String(data: data, encoding: .windowsCP1254)
    else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode HTML"])
    }

    let document = try SwiftSoup.parse(html)
    return document
}
// Files keyword filter due to website links attached with the news item in zamalektoday
func extractImageURL(from url: String) async throws -> URL? {

     let document = try await fetchHTML(from: url)

    let imageElements = try document.select("img")
    let srcs = imageElements.array().compactMap { try? $0.attr("src").trimmingCharacters(in: .whitespacesAndNewlines) }.filter { $0.contains("files") }

    return srcs.compactMap { URL(string: $0, relativeTo: URL(string: "https://www.zamalektoday.com/")) }.first

}
