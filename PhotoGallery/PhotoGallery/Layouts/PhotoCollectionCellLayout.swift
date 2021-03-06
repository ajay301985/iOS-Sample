//
//  PhotoCollectionCellLayout.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import Foundation
import UIKit

protocol PinterestLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class PhotoCollectionCellLayout: UICollectionViewLayout {
  // MARK: Internal

  weak var delegate: PinterestLayoutDelegate?


  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    calculateFrame()
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }

  // MARK: Private

  private let numberOfColumns = 2 // number of column in collection
  private var contentHeight: CGFloat = 0

  private var cache: [UICollectionViewLayoutAttributes] = []

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
}

extension PhotoCollectionCellLayout {
  private func calculateFrame() {
    guard
      cache.isEmpty == true,
      let collectionView = collectionView
    else {
      return
    }

    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

    let cellPadding: CGFloat = 3 //padding for cell
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)

      let photoHeight = delegate?.collectionView(
        collectionView,
        heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }

  func recalculateFrame() {
    cache.removeAll()
    calculateFrame()
  }
}
