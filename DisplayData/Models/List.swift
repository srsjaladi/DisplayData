//
//  File.swift
//  DisplayData
//
//  Created by Sivaramsingh on 18/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

//
//  Product.swift
//  Kollectin
//
//  Created by Pablo on 1/13/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

class  List {
    
    var image: String
    var info: String
    var title: String
    
    
    
    init(object: AnyObject) {
        let json = JSON(object)
        self.image = json["imageHref"].stringValue
        self.info = json["description"].stringValue
        self.title = json["title"].stringValue
     
    }
    
    init() {
        
        image = ""
       info = ""
        title = ""
    }
}



