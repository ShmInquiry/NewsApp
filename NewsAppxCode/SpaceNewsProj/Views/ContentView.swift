//
//  ContentView.swift
//  NewsAppxCode
//
//  Created by NBK on 18/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                fetchRSSFeed()
            }
    }
    
    func fetchRSSFeed() {
        if let url = URL(string: "https://news.google.com/rss") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
                }
            }
            task.resume()
        }
    }
}

extension ContentView: XMLParserDelegate {
    // Implement XMLParserDelegate methods here
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // Implement how you want to handle different XML elements
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Implement how you want to handle the content of XML elements
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // Parsing of the RSS feed is complete
    }
}

@main
struct NewsAppxCodeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
