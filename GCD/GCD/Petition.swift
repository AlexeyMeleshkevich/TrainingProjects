//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Alexey Meleshkevich on 08.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
