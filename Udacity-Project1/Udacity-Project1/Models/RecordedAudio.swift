//
//  RecordedAudio.swift
//  Udacity-Project1
//
//  Created by dvelasquez c on 9/28/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    
    required init(filePathUrl: NSURL, title: String) {
        super.init()
        
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
