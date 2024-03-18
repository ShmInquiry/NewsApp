//
//  ContentView.swift
//  NewsAppxCode
//
//  Created by NBK on 18/03/2024.
//

import SwiftUI
import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - XMLParserDelegate methods
    
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
