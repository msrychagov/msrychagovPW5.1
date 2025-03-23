import Foundation

final class NewsListInteractor: NewsListBusinessLogic {
    
    weak var output: NewsListInteractorOutput?
    
    private let decoder = JSONDecoder()
    
    // Пример подгрузки с Seldon News
    func loadArticles() {
        guard let url = URL(string: "https://news.myseldon.com/api/Section?rubricId=4&pageSize=8&pageIndex=1") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.output?.didFailLoading(with: error)
                }
                return
            }
            guard let self = self, let data = data else { return }
            
            do {
                var newsPage = try self.decoder.decode(NewsPage.self, from: data)
                // Проставляем requestId во все статьи
                newsPage.passRequestIdToArticles()
                
                let articles = newsPage.news ?? []
                
                DispatchQueue.main.async {
                    self.output?.didLoadArticles(articles)
                }
            } catch {
                DispatchQueue.main.async {
                    self.output?.didFailLoading(with: error)
                }
            }
        }
        
        task.resume()
    }
}
