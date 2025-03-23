import UIKit

final class NewsListViewController: UIViewController, NewsListViewInput {
    
    var output: NewsListViewOutput?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "News"

        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        output?.viewDidLoad()
    }
    
    // MARK: - NewsListViewInput
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfArticles() ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        else {
            return UITableViewCell()
        }
        let article = output?.article(at: indexPath.row)
        cell.configure(with: article)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        output?.didTapCell(at: indexPath.row)
    }
    
    // iOS 11+ добавляет trailingSwipeActionsConfigurationForRowAt
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] action, view, completion in
            self?.output?.didSwipeShare(at: indexPath.row) { url in
                guard let url = url else {
                    completion(false)
                    return
                }
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self?.present(activityVC, animated: true)
                completion(true)
            }
        }
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
}
