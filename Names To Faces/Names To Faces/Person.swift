//
//  Person.swift
//  Names To Faces
//
//  Created by Alexey Meleshkevich on 13.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
