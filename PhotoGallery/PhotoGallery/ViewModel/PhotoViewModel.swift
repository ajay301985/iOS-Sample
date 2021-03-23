//
//  PhotoViewModel.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import Foundation

final class PhotoViewModel {
  var photos: [PhotoList.Photo] = []

  func getPhotos(pageNumber: Int, query: String, completion: @escaping (Bool, NetworkError?) -> Void) {
    PhotoService.getPhotos(pageNumber: pageNumber, query: query) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let photoList):
          self.photos = photoList.photos
          completion(true, nil)
        case .failure(let error):
          completion(false, error)
      }
    }
  }

  func titleForPhoto(photo: PhotoList.Photo) -> String? {
    let photoDescription = (photo.description?.isEmpty ?? true ? photo.alt_description : photo.description) ?? ""
    return photoDescription
  }
}
