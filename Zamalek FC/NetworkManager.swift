//
//  NetworkManager.swift
//  Zamalek FC
//
//  Created by Mohamed Alwakil on 2025-03-18.
//
import Foundation
import FeedKit

protocol NetworkProtocol {
    func fetchData() async throws -> Data
}

class NetworkManager: NetworkProtocol {

    func fetchData() async throws -> Data {

        let url = URL.init(string: "https://www.zamalektoday.com/index.php?go=rss")!
        let result = try await URLSession.shared.data(from: url)
        return result.0
    }

}

