//
//  NewsFeedView.swift
//  Zamalek FC
//
//  Created by Mohamed Alwakil on 2025-03-18.
//

import SwiftUI
import FeedKit

extension URL {
    public static var `default` : URL {
        return URL.init(string: "https://www.zamalektoday.com")!
    }
}

struct NewsFeedView: View {

    @State var feedManager = FeedManager()
    @State var rssFeed: [RSSFeedItem] = []
    @State var isPresentWebView = false
    @State var selectedURL: URL = URL.default

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
            .sheet(isPresented: $isPresentWebView) {
                NavigationStack {
                    // 3

                    WebView(url: selectedURL)
                        .ignoresSafeArea()
                        .navigationTitle("Zamalek")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    @ViewBuilder
    func newsFeedRow(item: RSSFeedItem) -> some View {
        VStack(alignment: .trailing) {
            Text(item.title ?? "")
                .multilineTextAlignment(.trailing)
                .frame(maxHeight: .infinity)
                .padding()

            Text(item.description ?? "")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
                .padding()


            HStack {
                Text(item.pubDate?.formatted() ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)
            }
            .padding()

            Divider()

        }
        .onTapGesture {
            guard let link = item.link,
                  let url = URL.init(string: link)
            else { return }

            selectedURL = url
            isPresentWebView = true
        }

    }
}

#Preview {
    NewsFeedView()
}
