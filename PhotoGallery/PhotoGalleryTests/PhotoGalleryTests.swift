//
//  PhotoGalleryTests.swift
//  PhotoGalleryTests
//
//  Created by Ajay Rawat on 2021-03-22.
//

import XCTest
@testable import PhotoGallery

class PhotoGalleryTests: XCTestCase {

  func testUrlRequestWithPage() throws {
    let request = Request.getPhotos(1, 20, "nature")
    XCTAssertEqual(request.urlRequest.url?.description, "https://api.unsplash.com/search/photos?page=1&query=nature&per_page=20&client_id=L5IPYvVQ3ig6QLm3NzHWAlPvyPl3sxuYMXDLvrNHPqQ")
  }

  func testPhotoTitleWithDescription() throws {
    let creator = PhotoList.Photo.User(id: "12334", userName: "AjayRawat", name: "Ajay")
    let photoObj = PhotoList.Photo(isExpand: false, id: "234", description: "description", alt_description: nil, url: nil, width: 101, height: 100, user: creator)
    let viewModel = PhotoViewModel()
    let title = viewModel.titleForPhoto(photo: photoObj)
    XCTAssertEqual(title, "description")
  }

  func testPhotoTitleWithoutDescription() throws {
    let creator = PhotoList.Photo.User(id: "12334", userName: "AjayRawat", name: "Ajay")
    let photoObj = PhotoList.Photo(isExpand: false, id: "234", description: nil, alt_description: "alternative description", url: nil, width: 101, height: 100, user: creator)
    let viewModel = PhotoViewModel()
    let title = viewModel.titleForPhoto(photo: photoObj)
    XCTAssertEqual(title, "alternative description")
  }

  func testPhotoUser() throws {
    let creator = PhotoList.Photo.User(id: "12334", userName: "AjayRawat", name: "Ajay")
    XCTAssertEqual(creator.displayUserName, "Clicked By: AjayRawat")
  }

}
