import Foundation

final class NewsListPresenter: NewsListViewOutput, NewsListInteractorOutput {
    
    weak var view: NewsListViewInput?
    var interactor: NewsListBusinessLogic?
    var router: NewsListRouterLogic?
    
    private var articles: [ArticleModel] = []

    // MARK: - NewsListViewOutput
    func viewDidLoad() {
        interactor?.loadArticles()
    }
    
    func didTapCell(at index: Int) {
        guard index < articles.count else { return }
        let article = articles[index]
        guard let url = article.articleUrl else {
            view?.showError("Не удалось получить ссылку на статью.")
            return
        }
        router?.openDetailScreen(url: url)
    }
    
    func didSwipeShare(at index: Int, completion: @escaping (URL?) -> Void) {
        guard index < articles.count else {
            completion(nil)
            return
        }
        
        completion(articles[index].articleUrl)
    }
    
    func numberOfArticles() -> Int {
        return articles.count
    }
    
    func article(at index: Int) -> ArticleModel? {
        guard index < articles.count else { return nil }
        return articles[index]
    }
    
    // MARK: - NewsListInteractorOutput
    func didLoadArticles(_ articles: [ArticleModel]) {
        self.articles = articles
        view?.reloadData()
    }
    
    func didFailLoading(with error: Error) {
        view?.showError(error.localizedDescription)
    }
}
