//
//  NTDataModel.swift
//  NTFocusCollectionView
//
//  Created by Pham Nguyen Nhat Trung on 11/18/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation

struct NTDataModel {
  private var posts: [Post]?
  
  // MARK: Public methods
  func getNumbersOfPost() -> Int {
    guard let posts = posts else { return 0 }
    return posts.count
  }
  
  func getPost(index: Int) -> Post? {
    guard let posts = posts where index < getNumbersOfPost() else { return nil }
    return posts[index]
  }
  
  // MARK: Initialization
  init() {
    posts = loadData()
  }
  
  // MARK: Load Data
  private func loadData() -> [Post]? {
    guard let fileURL = NSBundle.mainBundle().URLForResource("Data", withExtension: "plist"),
      rawData = NSArray(contentsOfURL: fileURL)
      else { return nil }
    
    let parsedData = NSMutableArray()
    
    for data in rawData {
      if let data = data as? Dictionary<String, AnyObject>,
        post = Post(dataDictionary: data) {
        parsedData.addObject(post)
      }
    }
    return parsedData as AnyObject as? [Post]
  }
}