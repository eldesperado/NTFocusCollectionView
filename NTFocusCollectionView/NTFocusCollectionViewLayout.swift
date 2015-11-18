//
//  NTFocusCollectionViewLayout.swift
//  NTFocusCollectionView
//
//  Created by Pham Nguyen Nhat Trung on 11/18/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

@IBDesignable
public class NTFocusCollectionViewLayout: UICollectionViewLayout {
  // MARK: Attributes
  // Public Attributes
  @IBInspectable public var normalCellHeight: CGFloat = 100
  @IBInspectable public var focusedCellHeight: CGFloat = 280
  @IBInspectable public var minDragOffset: CGFloat = 180
  
  // Private Attributes
  private var cachedLayoutAttributes: [UICollectionViewLayoutAttributes]?
  
  // MARK: UICollectionViewLayout Methods
  /**
  Returns the size of the collection view’s contents
  
  - returns: Returns the size of the collection view’s contents
  */
  public override func collectionViewContentSize() -> CGSize {
    guard let collectionView = collectionView else { return CGSizeZero }
    
    let numberOfItems = collectionView.numberOfItemsInSection(0)
    let contentHeight = CGFloat(numberOfItems) * minDragOffset + (collectionView.frame.size.height - minDragOffset)
    return CGSizeMake(collectionView.frame.size.width, contentHeight)
  }
  
  /**
  Whenever its bound changes, require update the layout
  
  - parameter newBounds: The new bounds of the collection view.
  
  - returns: true
  */
  public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    let proposedContentOffset = round(proposedContentOffset.y / minDragOffset) * minDragOffset
    return CGPointMake(0, proposedContentOffset)
  }
  
  /**
  Return all attributes in cache whose frame intersects with the given rect passed to the method
  
  - parameter rect: The rectangle (specified in the collection view’s coordinate system) containing the target views.
  
  - returns: An array of UICollectionViewLayoutAttributes objects representing the layout information for the cells and views.
  */
  public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let cachedLayoutAttributes = cachedLayoutAttributes else { return [] }
    
    let layoutAttributes = NSMutableArray()
    
    for attributes in cachedLayoutAttributes {
      if CGRectIntersectsRect(attributes.frame , rect) {
        layoutAttributes.addObject(attributes)
      }
    }
    return layoutAttributes as AnyObject as? [UICollectionViewLayoutAttributes]
  }
  
  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard let cachedLayoutAttributes = cachedLayoutAttributes else { return nil }
    return cachedLayoutAttributes[indexPath.item]
  }
  
  public override func prepareLayout() {
    guard let collectionView = collectionView else { return }
    
    let numberOfItems = collectionView.numberOfItemsInSection(0)
    // Create new mutable array to store the collection view's layout attributes
    let cache = NSMutableArray()
    
    var frame = CGRectZero
    // The y-coordinate of the currently focused cell
    var y = CGFloat(0.0)
    
    for cell in 0..<numberOfItems {
      let indexPath = NSIndexPath(forItem: cell, inSection: 0)
      let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
      
      attributes.zIndex = cell
      // Initially set height of cell is equal to the normal cell height
      var cellHeight = normalCellHeight
      
      if cell == getCurrentFocusedCellIndex() {
        // If current cell is the focused cell then change its attributes
        let yOffset = normalCellHeight * CGFloat(getCurrentFocusedCellIndex())
        y = collectionView.contentOffset.y - yOffset
        // Change cell's height to the focused cell height
        cellHeight = focusedCellHeight
      } else if (cell == getCurrentFocusedCellIndex() + 1 && cell != numberOfItems + 1) {
        // Else if this is a cell directly below the currently focused cell, and it's not
        // the last cell
        let maxY = y + normalCellHeight
        let nextFocusedCellHeight = (focusedCellHeight - normalCellHeight) * getNextCellPercentageOffset()
        cellHeight = normalCellHeight + max(nextFocusedCellHeight, 0)
        // Change y
        y = maxY - cellHeight
      } else {
        y = frame.origin.y + frame.size.height
      }
      // Update frame
      frame = CGRectMake(0, y, collectionView.frame.size.width, cellHeight)
      attributes.frame = frame
      cache.addObject(attributes)
      y = CGRectGetMaxY(frame)
    }
    
    cachedLayoutAttributes = cache.copy() as? [UICollectionViewLayoutAttributes]
  }
  
  // MARK: Helpers
  /**
  Get the index of currently focused cell in collectionview
  
  - returns: The item index
  */
  private func getCurrentFocusedCellIndex() -> Int {
    guard let collectionView = collectionView else { return 0 }
    return Int(max(0, collectionView.contentOffset.y / minDragOffset))
  }
  
  /**
  Return a number whose value is in range from 0-1 which represents how close the next cell
  is becoming a new focused cell
  
  - returns: Percentage Offset
  */
  private func getNextCellPercentageOffset() -> CGFloat {
    guard let collectionView = collectionView else { return 0 }
    return collectionView.contentOffset.y / minDragOffset - CGFloat(getCurrentFocusedCellIndex())
  }
}
