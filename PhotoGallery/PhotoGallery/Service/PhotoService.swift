//
//  PhotoService.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import Foundation

final class PhotoService {
  // MARK: Internal

  static func getPhotos(pageNumber: Int, query: String, completion: @escaping (Swift.Result<PhotoList, NetworkError>) -> Void) {
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = TIMEOUT_INTERVAL
    URLSession(configuration: urlconfig).dataTask(with: Request.getPhotos(pageNumber, query).urlRequest) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
        (200 ... 299).contains(httpResponse.statusCode)
      else {
        completion(.failure(NetworkError.error()))
        return
      }
      do {
        guard let data = data else {
          completion(.failure(NetworkError.error()))
          return
        }
        let result = try JSONDecoder().decode(PhotoList.self, from: data)
        completion(.success(result))
      } catch {
        print(error.localizedDescription)
        completion(.failure(NetworkError.error(code: httpResponse.statusCode)))
      }
    }.resume()
  }

  // MARK: Private

  private static let TIMEOUT_INTERVAL = 60.0
}
