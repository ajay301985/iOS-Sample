//
//  NetworkRequest.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import Foundation

enum Request {
  case getPhotos(Int, String)

  // MARK: Internal

  var urlRequest: URLRequest {
    var urlRequest = URLRequest(url: URL(string: endpoint)!)
    urlRequest.httpMethod = httpMethod
    return urlRequest
  }

  // MARK: Private

  private var endpoint: String {
    switch self {
      case .getPhotos(let pageNumber, let query):
        return "https://api.unsplash.com/search/photos?page=\(pageNumber)&query=\(query)&client_id=\(clientId)"
    }
  }

  private var httpMethod: String {
    switch self {
      case .getPhotos:
        return "GET"
    }
  }

  private var clientId: String {
    return "L5IPYvVQ3ig6QLm3NzHWAlPvyPl3sxuYMXDLvrNHPqQ"
  }
}

enum NetworkError: Error {
  case badRequest
  case requestTimeOut
  case noNetworkConnection
  case unknown

  // MARK: Internal

  var errorMessage: String {
    switch self {
      case .badRequest:
        return "Check your network connection"
      case .unknown:
        return "Internal Server error: Server is not responding"
      default:
        return "Not connected to network or poor connection, check your network"
    }
  }

  var debugDescription: String {
    switch self {
      case .badRequest:
        return "Bad API request"
      case .unknown:
        return "Internal Server error"
      default:
        return "Request Time out"
    }
  }

  static func error(code: Int? = 0) -> NetworkError {
    switch code {
      case 400:
        return .badRequest
      case 500:
        return .unknown
      default:
        return requestTimeOut
    }
  }
}
