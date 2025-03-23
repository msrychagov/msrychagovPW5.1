import UIKit

final class NewsCell: UITableViewCell {
    
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // Чтобы не путать картинки
    private var currentURL: URL?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настройки imageView
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройки titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройки descriptionLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            // Картинка слева
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            newsImageView.widthAnchor.constraint(equalToConstant: 60),
            newsImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Заголовок справа от картинки
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Описание под заголовком
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Отступ снизу для корректной высоты
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(with article: ArticleModel?) {
        titleLabel.text = article?.title ?? "No title"
        descriptionLabel.text = article?.announce ?? "No description"
        
        if let url = article?.img?.url {
            loadImage(from: url)
        } else {
            newsImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        currentURL = url
        newsImageView.image = nil
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                if self?.currentURL == url {
                    self?.newsImageView.image = image
                }
            }
        }
    }
}
