//
//  NewsLastFetchedUtility.swift
//  NewsApp2
//
//  Created by ShM on 01/04/2024.
//

import Foundation

class NewsLastFetchedUtility {
    static func calculateTimeAgo(from publishedAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-HH-dd'T'HH:mm:ssZ"
        
        if let publishedAtDate = dateFormatter.date(from: publishedAt) {
            let timeDifference = abs(publishedAtDate.timeIntervalSinceNow)
            
            let hours = Int(timeDifference / 3600)
            let days = Int(timeDifference / (3600 * 24))
            let weeks = Int(timeDifference / (3600 * 24 * 7))
            let months = Int(timeDifference / (3600 * 24 * 30))
            
            if months > 0 {
                return "\(months) month\(months > 1 ? "s" : "") ago"
            } else if weeks > 0 {
                return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
            } else if days > 0 {
                return "\(days) day\(days > 1 ? "s" : "") ago"
            } else if hours > 0 {
                return "\(hours) hour\(hours > 1 ? "s" : "") ago"
            } else {
                return "just now"
            }
        } else {
            return "Invalid Date"
        }
    }
}
