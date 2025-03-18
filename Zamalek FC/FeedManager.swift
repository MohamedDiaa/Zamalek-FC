//
//  FeedManager.swift
//  Zamalek FC
//
//  Created by Mohamed Alwakil on 2025-03-18.
//
import Foundation
import FeedKit

class FeedManager {

    func fetchFeed() async-> RSSFeed? {

        let feedURL = URL(string: "https://www.zamalektoday.com/index.php?go=rss")!
        let feed =  await parseAsync(url: feedURL)
        return feed
    }

    func parseAsync(url: URL) async -> RSSFeed? {
        await withCheckedContinuation { continuation in

            let parser = FeedParser(URL: url)
            parser.parseAsync {(result) in
                switch result {
                case .success(let feed):
                    continuation.resume(returning: feed.rssFeed)

                case .failure(let error):
                    print(error)
                }
            }

        }
    }

}
