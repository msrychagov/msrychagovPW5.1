import Foundation

final class ArticleDetailPresenter: ArticleDetailPresentationLogic, ArticleDetailInteractorOutput {
    
    weak var view: ArticleDetailViewLogic?
    var interactor: ArticleDetailBusinessLogic?
    
    private let articleURL: URL
    
    init(articleURL: URL) {
        self.articleURL = articleURL
    }
    
    func viewDidLoad() {
        // Можно что-то запросить у Interactor
        interactor?.fetchSomethingIfNeeded()
        
        // Говорим View загрузить URL
        view?.loadWebPage(articleURL)
    }
}
