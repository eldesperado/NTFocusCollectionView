//
//  Post.swift
//  NTFocusCollectionView
//
//  Created by Pham Nguyen Nhat Trung on 11/18/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation
import UIKit

class Post {
  var title: String?
  var detail: String?
  var backgroundImage: UIImage?
}

extension Post {
  convenience init?(dataDictionary: Dictionary<String, AnyObject>) {
    self.init()
    self.title = dataDictionary["title"] as? String
    self.detail = dataDictionary["detail"] as? String
    if let imageName = dataDictionary["image"] as? String {
      self.backgroundImage = UIImage(named: imageName)
    }
  }
}


