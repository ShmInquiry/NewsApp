//
//  ViewController.swift
//  NewsApp2
//
//  Created by Sh.M on 18/03/2024.
//

import UIKit
import SafariServices

//Tableview
// Custom Cell
// Api caller
// Open the news stories
// Search for news stories

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        // Adding a "+" button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
        fetchTopStories()
    }
    
    @objc private func didTapAddButton(){
        // Present news alternatives
        presentNewsSourcesList()
    }
    
    private func presentNewsSourcesList(){
        // List of resources created and presented
        // Handle user selection to switch to selected news source
         let alertController = UIAlertController(title: "Select News Source", message: nil, preferredStyle: .actionSheet)
        
        // Add actions for different news sources
        let techCrunchAction = UIAlertAction(title: "TechCrunch", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.topHeadlinesURL ?? URL(string: "")!)
        }
        
        let wsjAction = UIAlertAction(title: "The Wall Street Journal", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.secondHeadlinesURL ?? URL(string: "")!)
        }
        
        let appleAction = UIAlertAction(title: "Apple News", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.thirdHeadlinesURL ?? URL(string: "")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        
        alertController.addAction(techCrunchAction)
        alertController.addAction(wsjAction)
        alertController.addAction(appleAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchNews(from url: URL) {
    // Fetch news from the specified API endpoint
    APICaller.shared.getTopStories { [weak self] result in
        switch result {
            case .success(let articles):
                // Update the articles and viewModels based on the fetched news
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    // Reload the table view to display the new news
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch news articles: \(error)")
            }
        }
    }
        
    private func fetchTopStories() {
        APICaller.shared.getTopStories{ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // Table views
    func tableView(_ tableview: UITableView, numberOfRowsInSection section : Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
                fatalError()
            }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // let viewModel = viewModels[indexPath.row]
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url : url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
