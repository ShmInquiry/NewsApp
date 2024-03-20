//
//  APICaller.swift
//  NewsApp2
//
//  Created by Sh.M on 18/03/2024.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    struct Constats {
        static let topHeadlinesURL  = URL (string:
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=274099a79e6d4a679542c030ea58adc2")
    
        static let secondHeadlinesURL  = URL (string:
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=274099a79e6d4a679542c030ea58adc2")
        
        static let thirdHeadlinesURL  = URL (string:
        "https://newsapi.org/v2/everything?q=apple&from=2024-03-17&to=2024-03-17&sortBy=popularity&apiKey=274099a79e6d4a679542c030ea58adc2")


    }
    
    private init() {}

    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void)
    {
        guard let url = Constats.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    //
    public func getTopStories2(completion: @escaping (Result<[Article], Error>) -> Void)
    {
        guard let url = Constats.secondHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    //
    public func getTopStories3(completion: @escaping (Result<[Article], Error>) -> Void)
    {
        guard let url = Constats.thirdHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func fetchNews(from url: URL, completion: @escaping (Result<[Article], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable{
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
