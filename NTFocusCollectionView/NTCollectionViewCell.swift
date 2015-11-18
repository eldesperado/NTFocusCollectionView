//
//  NTCollectionViewCell.swift
//  NTFocusCollectionView
//
//  Created by Pham Nguyen Nhat Trung on 11/18/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var overlayView: UIView!
  
  @IBInspectable var maxOverlayViewAlpha: CGFloat = 0.75
  @IBInspectable var minOverlayViewAlpha: CGFloat = 0.35
  
  func configureCell(post: Post) {
    titleLabel.text = post.title ?? ""
    detailLabel.text = post.detail ?? ""
    backgroundImageView.image = post.backgroundImage
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    super.applyLayoutAttributes(layoutAttributes)
    
    let focusedCellHeight: CGFloat = 280
    let normalCellHeight: CGFloat = 100
    let delta = 1 - ((focusedCellHeight - CGRectGetHeight(frame)) / (focusedCellHeight - normalCellHeight))
    
    let alpha = maxOverlayViewAlpha - (delta * (maxOverlayViewAlpha - minOverlayViewAlpha))
    overlayView.alpha = alpha
    let scale = max(delta, 0.5)
    titleLabel.transform = CGAffineTransformMakeScale(scale, scale)
    detailLabel.alpha = delta
  }
}
