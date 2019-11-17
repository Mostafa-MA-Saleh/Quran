//
//  QuranAPIManager.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import Alamofire
import CodableAlamofire
import Foundation

class QuranApiManager {
    static let shared = QuranApiManager()

    private let BASE_URL = "http://api.alquran.cloud/v1/page/%i/quran-uthmani"

    private init() {}

    func fetch(pageNumber: Int, for surahNumber: Int, completion: @escaping (Result<Page>) -> Void) {
        let pageUrl = String(format: BASE_URL, pageNumber)
        Alamofire.request(pageUrl).responseDecodableObject(keyPath: "data") { (response: DataResponse<Page>) in
            switch response.result {
            case let .success(page): completion(.success(page.filter(for: surahNumber)))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
