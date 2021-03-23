//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import UIKit

final class ViewController: UIViewController {
  // MARK: Internal

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var headerView: HeaderView!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let layout = collectionView?.collectionViewLayout as? PhotoCollectionCellLayout {
      layout.delegate = self
    }

    loadPhotos(pageNumer: 1, queryString: queryString)
  }

  // MARK: Private

  private struct Constants {
    static let HeaderHeight: CGFloat = 80
    static let HeaderMinimumHeight: CGFloat = 50
    static let HeaderAnimationDuration = 1.0
  }

  private let viewModel = PhotoViewModel()
  private let imageLoader = ImageDownloader()
  private let queryString = "nature"
  private let cellIdentifier = "photoCellIdentifier"
  private let currentPage = 1
  private let itemCount = 30
  private var isShowingHeader = false

  private func loadPhotos(pageNumer: Int, queryString: String) {
    viewModel.getPhotos(pageNumber: pageNumer, count: itemCount, query: queryString) { [weak self] isSuccess, error in
      guard let self = self else { return }
      DispatchQueue.main.async {
        if isSuccess {
          self.reloadTableData()
        } else {
          self.displayAlertMessage(message: error?.errorMessage)
        }
      }
    }
  }

  private func reloadTableData() {
    headerView.setTitle(title: queryString.capitalized)
    collectionView?.reloadData()
  }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.photos.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCollectionViewCell

    let currentPhoto = viewModel.photos[indexPath.item]
    cell.titleLabel.text = viewModel.titleForPhoto(photo: currentPhoto)
    cell.authorLabel.text = currentPhoto.user.displayUserName
    guard let imagePath = currentPhoto.url?.small else {
      return cell
    }

    if currentPhoto.isExpand {
      cell.expandTitle()
    } else {
      cell.collapseTitle()
    }
    imageLoader.obtainImageWithPath(imagePath: imagePath) { image in
      DispatchQueue.main.async {
        cell.imageView.image = image
        cell.setNeedsLayout()
      }
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var currentPhoto = viewModel.photos[indexPath.item]
    currentPhoto.isExpand.toggle()
    viewModel.photos[indexPath.item] = currentPhoto
    var preLayout: PhotoCollectionCellLayout!
    if let layout = collectionView.collectionViewLayout as? PhotoCollectionCellLayout {
      layout.recalculateFrame()
      preLayout = layout
      collectionView.reloadItems(at: [indexPath])
      self.collectionView?.collectionViewLayout.invalidateLayout()
      self.collectionView?.setCollectionViewLayout(preLayout, animated: true)
    }
  }
}

extension ViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > Constants.HeaderHeight, isShowingHeader {
      isShowingHeader.toggle()
      UIView.animate(withDuration: Constants.HeaderAnimationDuration, delay: 0.0, options: .transitionCrossDissolve, animations: {
        self.headerViewHeightConstraint.constant = Constants.HeaderMinimumHeight
        self.view.layoutIfNeeded()
      }, completion: nil)
    } else if scrollView.contentOffset.y < Constants.HeaderHeight, !isShowingHeader {
      isShowingHeader.toggle()
      UIView.animate(withDuration: Constants.HeaderAnimationDuration, delay: 0.0, options: .transitionCrossDissolve, animations: {
        self.headerViewHeightConstraint.constant = Constants.HeaderHeight
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
  }
}

extension ViewController: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
  {
    let currentPhoto = viewModel.photos[indexPath.item]
    let calculatedHeight = currentPhoto.isExpand ? currentPhoto.calculatedHeight : (currentPhoto.calculatedHeight - Float(EXPAND_CELL_HEIGHT))
    return CGFloat(calculatedHeight)
  }
}
