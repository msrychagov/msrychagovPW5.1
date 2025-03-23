import UIKit

final class NewsCell: UITableViewCell {
    
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            newsImageView.widthAnchor.constraint(equalToConstant: 60),
            newsImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(with article: ArticleModel?) {
        titleLabel.text = article?.title ?? "No title"
        descriptionLabel.text = article?.announce ?? "No description"
        
        // Перед загрузкой картинки — сброс
        newsImageView.image = nil
        
        guard let url = article?.img?.url else {
            // Нет URL картинки — убираем shimmer на всякий случай
            newsImageView.stopShimmering()
            return
        }
        
        // Запускаем shimmer, пока загружается изображение
        newsImageView.startShimmering()
        
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        currentURL = url
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else {
                // Загрузка не удалась — убираем shimmer, но не выставляем картинку
                DispatchQueue.main.async {
                    self?.newsImageView.stopShimmering()
                }
                return
            }
            
            DispatchQueue.main.async {
                // Если URL не успел измениться при переиспользовании ячейки
                if self?.currentURL == url {
                    self?.newsImageView.image = image
                }
                // В любом случае останавливаем shimmer
                self?.newsImageView.stopShimmering()
            }
        }
    }
}
