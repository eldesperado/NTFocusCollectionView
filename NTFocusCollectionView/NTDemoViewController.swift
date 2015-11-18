//
//  NTDemoViewController.swift
//  NTFocusCollectionView
//
//  Created by Pham Nguyen Nhat Trung on 11/18/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class NTDemoViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: Attributes
  private lazy var dataModel: NTDataModel = {
    return NTDataModel()
    }()
  
  // MARK: Constants
  let cellIdentifierKey = "collectionCell"
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
  }
}

extension NTDemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  // MARK: UICollectionViewDataSource methods
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataModel.getNumbersOfPost()
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierKey, forIndexPath: indexPath) as! NTCollectionViewCell
    return cell
  }
  
  // MARK: UICollectionViewDelegate methods
  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    guard let customCell = cell as? NTCollectionViewCell, post = dataModel.getPost(indexPath.row) else { return }
    customCell.configureCell(post)
  }
}
