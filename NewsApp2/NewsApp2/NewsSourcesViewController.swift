//
//  NewsSourcesViewController.swift
//  NewsApp2
//
//  Created by NBK on 20/03/2024.
//

import Foundation
import UIKit

protocol NewsSourcesViewControllerDelegate: AnyObject {
    func didSelectNewsSource(_ newsSource: NewsSource)
}

class NewsSourcesViewController: UITableViewController {
    weak var delegate: NewsSourcesViewControllerDelegate?
    
    var newsSources: [NewsSource] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsSourceCell", for: indexPath)
        let newsSource = newsSources[indexPath.row]
        cell.textLabel?.text = newsSource.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNewsSource = newsSources[indexPath.row]
        delegate?.didSelectNewsSource(selectedNewsSource)
        dismiss(animated: true, completion: nil)
    }
}