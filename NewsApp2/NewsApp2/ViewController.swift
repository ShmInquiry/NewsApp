//
//  ViewController.swift
//  NewsApp2
//
//  Created by Sh.M on 18/03/2024.
//
import Swift
import UIKit
import SafariServices

//Tableview
// Custom Cell
// Api caller
// Open the news stories
// Search for news stories


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Add search bar:
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search News"
        return searchBar
    }()
    
    private var isSearching = false
    private var filteredViewModels = [NewsTableViewCellViewModel]()
    

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the background gray
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        // Do any additional setup after loading the view.
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // view.backgroundColor = .systemBackground
        
        // Adding a "BookMark" button to the navigation bar //was '+'
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: self, action: #selector(didTapAddButton))
        
        //Add search bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        // Add pull to refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchTopStories()
        
        tableView.separatorStyle = .none
    }
    
    @objc private func refreshNews() {
        // Fetch news agin
        fetchTopStories()
    }
    
    @objc private func didTapAddButton(){
        // Present news alternatives
        presentNewsSourcesList()
    }
    
    @objc private func didTapSearchButton(){
        // Present news alternatives
        //SearchInAllNewsSourcesList()
    }
        
    private func presentNewsSourcesList(){
        // List of resources created and presented
        // Handle user selection to switch to selected news source
         let alertController = UIAlertController(title: "Select News Source", message: nil, preferredStyle: .actionSheet)
        
        // Add actions for different news sources
        let techCrunchAction = UIAlertAction(title: "TechCrunch", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.topHeadlinesURL!)
        }
        
        let wsjAction = UIAlertAction(title: "The Wall Street Journal", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.secondHeadlinesURL!)
        }
        
        let appleAction = UIAlertAction(title: "Apple News", style: .default) { [weak self] _ in
            self?.fetchNews(from: APICaller.Constats.thirdHeadlinesURL!)
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
        // Determine which API endpoint to use based on the URL
        /*if url == APICaller.Constats.topHeadlinesURL {
            APICaller.shared.getTopStories { [weak self] result in
                // Handle the result
                // ...
            }
        } else if url == APICaller.Constats.secondHeadlinesURL {
            APICaller.shared.getTopStories2 { [weak self] result in
                // Handle the result
                // ...
            }
        } else if url == APICaller.Constats.thirdHeadlinesURL {
            APICaller.shared.getTopStories3 { [weak self] result in
                // Handle the result
                // ...
            }
        }*/
    
    APICaller.shared.fetchNews(from: url) {[weak self] result in
        switch result {
        case .success(let articles):
            self?.articles = articles
            self?.viewModels = articles.map { article in
                if let imageURLString = article.urlToImage, let imageURL =  URL(string: imageURLString) {
                    print("Article publishedAt: \(article.publishedAt)")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ssZ"
                     if let date = dateFormatter.date(from: article.publishedAt) {
                         let dateString = dateFormatter.string(from: date)
                     }
                    return NewsTableViewCellViewModel(title: article.title ?? "", subtitle: article.description ?? "", imageURL: imageURL, author: article.author ?? "", publishedAt: article.publishedAt ?? "")

                }
                else {
                    return NewsTableViewCellViewModel(title: article.title ?? "", subtitle: article.description ?? "", imageURL: nil, author: article.author ?? "", publishedAt: article.publishedAt)
                }
            }.compactMap { $0 }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        case .failure(let error):
            print("Error fetching: \(error)")
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
                        imageURL: URL(string: $0.urlToImage ?? ""), author: $0.author ?? "Unknown Author",
                        publishedAt: $0.publishedAt
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing() // stop refresh anim
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
        
        tableView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty{
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredViewModels = viewModels.filter{
                $0.title.lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
    
    // Table views: updated 39th commit, returns count of eithers viewModels or filteredModels
    func tableView(_ tableview: UITableView, numberOfRowsInSection section : Int) -> Int {
        return isSearching ? filteredViewModels.count : viewModels.count
        //return viewModels.count
    }
    
    //39th commit update: cellForRowAt uses filteredViewModels when search in progress
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
                fatalError()
            }
        let viewModel = isSearching ? filteredViewModels[indexPath.row] : viewModels[indexPath.row]
        cell.configure(with: viewModel)
        //        cell.configure(with: viewModels[indexPath.row])
        //        cell.configure(with: viewModels[indexPath.row])

        return cell
            }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // let viewModel = viewModels[indexPath.row]
       /* let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url : url)
        present(vc, animated: true)
     */
    let selectedArticle = articles[indexPath.row]

    // Create a new instance of NewsDetailsViewController
    let newsDetailsViewController = NewsDetailsViewController(article: selectedArticle)
//    let newsDetailsViewController = NewsDetailsViewController(article: selectedArticle, titleV: title ?? "", subtitle: description ?? "")
    
    // Present the NewsDetailsViewController
    navigationController?.pushViewController(newsDetailsViewController, animated: true)


    /*// Create a new instance of NewsDetailsViewController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let newsDetailsViewController = storyboard.instantiateViewController(identifier: "NewsDetailsViewController") as? NewsDetailsViewController else {
        // Display news details in a separate view
        let newsDetailsViewController = NewsDetailsViewController(article: selectedArticle)
        navigationController?.pushViewController(newsDetailsViewController, animated: true)
        return
        }
    // Present the NewsDetailsViewController
    navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
    /// Display news details in a separate view
    let newsDetailsViewController = NewsDetailsViewController(article: selectedArticle)
    navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }*/
   }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.prefersLargeTitles = true
        
            //Set navigation bar on top of the app to custom height size
        navigationController?.navigationBar.frame.size.height = 49
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBarsOnTap = true
        
            //Update Appearance of navi bar
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .cyan
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = .systemGray5
            return headerView
        }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tabBarController?.tabBar.barTintColor = UIColor.brown
        
        return 150
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterSection section: Int) -> UIView?{
//        let footerView = UIView()
//        footerView.backgroundColor = .clear
//        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
//        return footerView
//    }
    
    func tableView(_ tableView: UITableView, heightRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
