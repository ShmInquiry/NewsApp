//
//  NewsTableViewCell.swift
//  NewsApp2
//
//  Created by Sh.M on 19/03/2024.
//

import Foundation
import UIKit

let date = Date()
let dateFormatter = DateFormatter()

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    let author: String?
    let publishedAt: String
    
//    dateFormatter.dateFormat = "dd/MM/yy"
//    dateFormatter.string(from: date)
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?,
        author: String?,
        publishedAt: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.author = author
        self.publishedAt = publishedAt
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let timePosted: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        backgroundColor = .systemGray5

        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(timePosted)


    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 185,
            height: contentView.frame.size.height/2)
        
        subTitleLabel.frame = CGRect(
            x: 20,
            y: 60,
            width: contentView.frame.size.width - 185,
            height: 50)
        
        authorLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 185,
            height: 100)
//        authorLabel.textAlignment = .rightAnchor
        
        timePosted.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 185,
            height: 100)
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 163,
            y: 7,
            width: 140,
            height: contentView.frame.size.height - 30)
        
        // Make the cells rounded
        contentView.layer.cornerRadius = contentView.frame.size.height / 12
        contentView.clipsToBounds = true
                    
        // Add empty space between cells/ Gaps
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        authorLabel.text = nil
        timePosted.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        authorLabel.text = viewModel.author
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH"
//        timePosted.text = dateFormatter.string(from: viewModel.publishedAt)


        
        //image
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            // fetch the image
            URLSession.shared.dataTask(with: url) { [weak self]
                data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
