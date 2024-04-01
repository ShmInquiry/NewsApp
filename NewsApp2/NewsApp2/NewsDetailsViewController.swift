import UIKit
import SafariServices

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
    
    //Customize Navi Bar
    
    
    //Object function that handles taps on links
    @objc func handleTap(){
        if let url = URL(string: article.url){
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
            //UIApplication.shared.open(url)
        }
    }

    
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
        //Configure screen center for compatiability across devices
        let centerX = view.frame.size.width / 2
        let centerY = view.frame.size.height / 2
        let topMargin: CGFloat = 40
        
        // Configure UI components and layout
        
        let title = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 15,y: view.frame.size.width  / 1.35), size: CGSize(width: 370, height: 205)))
        title.numberOfLines = 175
        title.font = .systemFont(ofSize: 27, weight: .semibold)
        title.clipsToBounds = true
        title.layer.cornerRadius = 30.0
        title.textColor = .black
        title.text = article.title
        title.heightAnchor.constraint(equalToConstant: 100).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.textAlignment = .center

        //The grey label behind the title and the time post, and the author name
        let titleBg = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 15,y: view.frame.size.width  / 1.25), size: CGSize(width: 370, height: 235)))
        titleBg.numberOfLines = 175
        titleBg.clipsToBounds = true
        titleBg.layer.cornerRadius = 30.0
        titleBg.backgroundColor = .systemGray5
        titleBg.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleBg.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleBg.textAlignment = .center
        
        let description = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 25,y: view.frame.size.width  / 1), size: CGSize(width: 350, height: 470)))
        description.numberOfLines = 5000
        description.font = .systemFont(ofSize: 20, weight: .regular)
        description.textColor = .black
        description.text = article.content
        description.textAlignment = .justified
        
        let timePosted = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 10,y: view.frame.size.width  / 1.43), size: CGSize(width: 350, height: 470)))
        timePosted.font = .systemFont(ofSize: 20, weight: .light)
        timePosted.textColor = .black
        timePosted.textAlignment = .left
       //timePosted.text = fetchNews()
    
        let Author = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width  / 14,y: view.frame.size.width  / 1.31), size: CGSize(width: 350, height: 470)))
        Author.font = .systemFont(ofSize: 20, weight: .medium)
        Author.textColor = .black
        Author.text = "Author: " + article.author
        Author.textAlignment = .right
        Author.lineBreakMode = .byTruncatingTail
        Author.numberOfLines = 2
        
        let LinkUrl = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 440), size: CGSize(width: 350, height: 880)))
        LinkUrl.font = .systemFont(ofSize: 20, weight: .light)
        LinkUrl.textColor = .blue
        //LinkUrl.toggleUnderline(Any?.self)
        LinkUrl.text = article.url
        
        //Handle link click
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        LinkUrl.isUserInteractionEnabled = true
        LinkUrl.addGestureRecognizer(tapGesture)

        //Setting image size and height
        let imageWidth: CGFloat = 410
        let imageHeight: CGFloat = 330
        newsImageView.frame = CGRect(x: centerX - (imageWidth / 2), y: topMargin, width: imageWidth, height: imageHeight)
        newsImageView.layer.cornerRadius = 50
        newsImageView.layer.masksToBounds = true
      
//
        configure(publishedAt: article.publishedAt, timePosted: timePosted)

        view.addSubview(newsImageView)
        view.addSubview(titleBg)
        view.addSubview(title)
        view.addSubview(timePosted)
        view.addSubview(Author)
        
        view.addSubview(description)
        
        view.addSubview(LinkUrl)
        
        
        

    }
    
    func configure(publishedAt: String, timePosted: UILabel) {
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
        
        let timeAgoString = NewsLastFetchedUtility.calculateTimeAgo(from: publishedAt)
        timePosted.text = timeAgoString
        
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

