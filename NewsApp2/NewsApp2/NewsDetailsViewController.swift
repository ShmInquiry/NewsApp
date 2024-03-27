import UIKit
import SwiftUI


enum ConstraintType {
    case top, leading, trailing, bottom, width, height
}

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> [ConstraintType : NSLayoutConstraint] {
        //translate the view's autoresizing mask into Auto Layout constraints
        translatesAutoresizingMaskIntoConstraints = false

        var constraints: [ConstraintType : NSLayoutConstraint] = [:]

        if let top = top {
            constraints[.top] = topAnchor.constraint(equalTo: top, constant: padding.top)
        }

        if let leading = leading {
            constraints[.leading] = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }

        if let bottom = bottom {
            constraints[.bottom] = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }

        if let trailing = trailing {
            constraints[.trailing] = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }

        if size.width != 0 {
            constraints[.width] = widthAnchor.constraint(equalToConstant: size.width)
        }

        if size.height != 0 {
            constraints[.height] = heightAnchor.constraint(equalToConstant: size.height)
        }
        let constraintsArray = Array<NSLayoutConstraint>(constraints.values)
        NSLayoutConstraint.activate(constraintsArray)
        return constraints
    }
}


class NewsDetailsViewController: UIViewController {
    
    private let article: Article
    // Add UI components to display news details
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        // Initialize UI components and populate with news details
        view.backgroundColor = .white
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure UI components and layout
        
        let title = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 15,y: view.frame.size.width  / 1.25), size: CGSize(width: 370, height: 150)))
        title.numberOfLines = 175
        title.font = .systemFont(ofSize: 30, weight: .semibold)
        title.clipsToBounds = true
        title.layer.cornerRadius = 30.0
        title.textColor = .black
        title.text = article.title
        title.backgroundColor = .systemGray5
        title.heightAnchor.constraint(equalToConstant: 100).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.textAlignment = .center
//        title.textAlignment = AnchorPoint()
                
        
        let description = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 25,y: view.frame.size.width  / 1.15), size: CGSize(width: 350, height: 470)))
        description.numberOfLines = 5000
        description.font = .systemFont(ofSize: 20, weight: .regular)
        description.textColor = .black
        description.text = article.content
//        label.textAlignment =
        
        let publishedDate = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 15,y: view.frame.size.width  / 0.7), size: CGSize(width: 350, height: 470)))
        publishedDate.font = .systemFont(ofSize: 20, weight: .light)
        publishedDate.textColor = .black
        publishedDate.text = article.publishedAt
        
        let Author = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 15,y: view.frame.size.width  / 1.55), size: CGSize(width: 350, height: 470)))
        Author.font = .systemFont(ofSize: 20, weight: .medium)
        Author.textColor = .black
        Author.text = "Author: " + article.author
        
        let LinkUrl = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 440), size: CGSize(width: 350, height: 880)))
        LinkUrl.font = .systemFont(ofSize: 20, weight: .light)
        LinkUrl.textColor = .blue
//        LinkUrl.toggleUnderline(Any?.self)
        LinkUrl.text = article.url
        
        newsImageView.frame = CGRect(origin: CGPoint(x: 0,y: 80), size: CGSize(width: 428, height: 325))
        
        
        
//        var previous: UILabel?
//
//        for label in [title, publishedDate, Author, description, LinkUrl] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//
//
//            if let previous = previous {
//                // we have a previous label – create a height constraint
//                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//            } else {
//                // this is the first label
//                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//            }
//
//
//            // set the previous label to be the current one, for the next loop iteration
//            previous = label
//        }
//
        
        view.addSubview(newsImageView)
        configure()
        
        view.addSubview(title)
        view.addSubview(publishedDate)
        view.addSubview(Author)
        
        view.addSubview(description)
        
        view.addSubview(LinkUrl)


////        view.addSubview(sceneView)
//        title.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func configure() {
        //image
        if let url = URL(string: article.urlToImage ?? "") {
            // fetch the image
            URLSession.shared.dataTask(with: url) { [weak self]
                data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.contentScaleFactor = .leastNormalMagnitude
        return imageView
    }()
}


