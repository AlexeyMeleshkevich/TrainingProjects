//
//  Person.swift
//  Names To Faces
//
//  Created by Alexey Meleshkevich on 13.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(image, forKey: "image")
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        image = coder.decodeObject(forKey: "image") as? String ?? ""
//    }
}
