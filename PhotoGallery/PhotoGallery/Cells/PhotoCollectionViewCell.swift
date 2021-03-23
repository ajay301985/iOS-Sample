//
//  PhotoCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Ajay Rawat on 2021-03-22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var labelHeightConstraint: NSLayoutConstraint!

  func collapseTitle() {
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
      self.labelHeightConstraint.constant = 0
      self.contentView.layoutIfNeeded()
    }, completion: nil)
  }

  func expandTitle() {
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
      self.labelHeightConstraint.constant = 60
      self.contentView.layoutIfNeeded()
    }, completion: nil)
  }
}
