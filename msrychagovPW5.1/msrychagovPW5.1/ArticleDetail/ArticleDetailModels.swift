import Foundation

struct NewsPage: Decodable {
    var news: [ArticleModel]?
    var requestId: String?
    
    mutating func passRequestIdToArticles() {
        guard let req = requestId else { return }
        for i in 0..<(news?.count ?? 0) {
            news?[i].requestId = req
        }
    }
}

struct ArticleModel: Decodable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    
    var requestId: String?
    
    var articleUrl: URL? {
        let rid = requestId ?? ""
        let nid = newsId ?? 0
        return URL(string: "https://news.myseldon.com/ru/news/index/\(nid)?requestId=\(rid)")
    }
}

struct ImageContainer: Decodable {
    var url: URL?
}
