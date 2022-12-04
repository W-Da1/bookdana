//
//  GoogleBookAPI.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/30.
//

import UIKit
import SwiftyJSON

struct Book {
    let title: String
    let publishDate: String
    let author: String
    let thumbnail: UIImage
}

class GoogleBookAPI: NSObject {
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
    let ISBN: String
    
    init(ISBN: String) {
        self.ISBN = ISBN
    }
    
    enum GoogleBooksAPIError: Error {
        case invalidURLString
        case notFound
    }
    
    func getBookData() async throws -> Book {
        
        let data = try await downloadData(urlString: baseURL + ISBN)
        let json = JSON(data)["items"]
        
        guard let title = json[0]["volumeInfo"]["title"].string else { throw GoogleBooksAPIError.notFound }//本のタイトルがなければ見つからなかった判定
        
        let pubDate = json[0]["publishedDate"].string ?? "????"
        let author = json[0]["volumeInfo"]["authors"].array?.compactMap { $0.string }.joined(separator: ",") ?? "????" //複数名の著者の場合まとめる
        
        if let imageURL = json[0]["imageLinks"]["thumbnail"].string {
            let imageData = try await downloadData(urlString: imageURL)
            return Book(title: title, publishDate: pubDate, author: author, thumbnail: UIImage(data: imageData)!)
        } else {
            return Book(title: title, publishDate: pubDate, author: author, thumbnail: UIImage())
        }
    }
    
    final func downloadData(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw GoogleBooksAPIError.invalidURLString
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
