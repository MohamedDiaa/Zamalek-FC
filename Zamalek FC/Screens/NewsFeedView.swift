//
//  NewsFeedView.swift
//  Zamalek FC
//
//  Created by Mohamed Alwakil on 2025-03-18.
//

import SwiftUI
import FeedKit

struct NewsFeedView: View {

    @State var feedManager = FeedManager()
    @State var rssFeed: [RSSFeedItem] = []

    var body: some View {

        VStack {
            Text("Zamalek FC")
                .font(.headline)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(rssFeed,id: \.title) { item in

                        newsFeedRow(item: item)
                    }
                }
            }
            .task {
                let feed = await feedManager.fetchFeed()
                rssFeed = feed?.items ?? []
            }
        }
    }

    @ViewBuilder
    func newsFeedRow(item: RSSFeedItem) -> some View {
        VStack(alignment: .trailing) {
            Text(item.title ?? "")
                .padding()
            Text(item.description ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()
        }

    }
}

#Preview {
    NewsFeedView()
}
