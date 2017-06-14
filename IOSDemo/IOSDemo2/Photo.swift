//
//  Photo.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 10/30/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

enum photoType: NSInteger {
    case localPhoto
    case cloudPhoto
    case localVideo
    case cloudVideo
}

class Photo: NSObject {
    var photoUUID: String!
    var userUUID: String!
    var type: photoType!
    
    var date: Date?
    
    var width: CGFloat!
    var height: CGFloat!
    
    var lowResUrl: URL?
    var hiResUrl: URL?
    var localUrl: URL?
    
    init(url: URL, objectType: photoType) {
        localUrl = url
        photoUUID = UUIDfromURL(url)
        lowResUrl = nil
        hiResUrl = nil
        // MARK: WARNING: UUID should be unique, like user Id. users' names can be duplicated
        userUUID = DataSourceStore.meDataSource.userInfoItem.username
        date = Date(timeIntervalSinceNow: 0)
        type = objectType
    }
}

var photoInfo = [Photo]()

