//
//  PhotoCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import UIKit

let EXPAND_CELL_HEIGHT: CGFloat = 50

class PhotoCollectionViewCell: UICollectionViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var labelHeightConstraint: NSLayoutConstraint!

  func collapseTitle() {
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
      self.labelHeightConstraint.constant = 0
      self.contentView.layoutIfNeeded()
    }, completion: nil)
  }

  func expandTitle() {
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
      self.labelHeightConstraint.constant = EXPAND_CELL_HEIGHT
      self.contentView.layoutIfNeeded()
    }, completion: nil)
  }
}
