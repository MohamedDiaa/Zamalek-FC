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


extension FeedManager {

    func fetchFeedWithImages() async -> [ItemFeed]? {

        let rssfeed = await fetchFeed()

        guard let items = rssfeed?.items
        else { return nil }

        var list: [ItemFeed] = []

        for item in items {
            if let link = item.link {

                let imgLink = try? await extractImageURL(from: link)
                list.append(.init(title: item.title,
                                  description: item.description,
                                  link: item.link,
                                  pubDate: item.pubDate,
                                  image: imgLink))
            }
        }
        return list
    }

}
