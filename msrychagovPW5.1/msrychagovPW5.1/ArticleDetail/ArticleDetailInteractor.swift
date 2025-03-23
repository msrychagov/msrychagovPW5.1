import Foundation

final class ArticleDetailInteractor: ArticleDetailBusinessLogic {
    
    weak var presenter: ArticleDetailPresentationLogic?
    
    func fetchSomethingIfNeeded() {
        // Если нужно что-то подгружать асинхронно — делаем это здесь
    }
}
