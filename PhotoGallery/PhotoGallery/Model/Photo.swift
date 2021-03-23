//
//  Photo.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import Foundation

private enum PhotoListCodingKeys: String, CodingKey {
  case total
  case total_pages
  case results
}

extension PhotoList {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PhotoListCodingKeys.self)
    total = try container.decode(Int.self, forKey: .total)
    total_pages = try container.decode(Int.self, forKey: .total_pages)
    photos = try container.decode([Photo].self, forKey: .results)
  }
}

struct PhotoList: Decodable {
  struct Photo: Decodable {
    struct User: Decodable {
      var id: String
      var userName: String
      var name: String
    }

    struct Url: Decodable {
      var raw: String?
      var full: String?
      var regular: String?
      var small: String?
      var thumb: String?
    }

    var isExpand: Bool
    var id: String
    var description: String?
    var alt_description: String?
    var url: Url?
    var width: Float
    var height: Float
    var user: User
  }

  var total: Int
  var total_pages: Int
  var photos: [Photo]
}

private enum CodingKeys: String, CodingKey {
  case id
  case description
  case alt_description
  case width
  case height
  case urls
  case user
}

extension PhotoList.Photo {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    alt_description = try container.decodeIfPresent(String.self, forKey: .alt_description)
    width = try container.decode(Float.self, forKey: .width)
    height = try container.decode(Float.self, forKey: .height)
    url = try container.decode(Url.self, forKey: .urls)
    user = try container.decode(User.self, forKey: .user)
    isExpand = false
  }
}

private enum UserCodingKeys: String, CodingKey {
  case id
  case username
  case name
}

extension PhotoList.Photo.User {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserCodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    userName = try container.decode(String.self, forKey: .username)
    name = try container.decode(String.self, forKey: .name)
  }

  var displayUserName: String {
    return "Clicked By: \(userName)"
  }
}

extension PhotoList.Photo {
  var calculatedHeight: Float {
    return (height * 0.050)
  }
}
