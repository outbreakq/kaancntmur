//
//  Notlar.swift
//  ToDoListApp
//
//  Created by Kaan Cantimur on 17.04.2023.
//

import Foundation

class Notlar {
    var not_id: Int?
    var not_kendi: String?
    var favori: Bool
    
    init(not_id: Int, not_kendi: String, favori: Bool) {
        self.not_id = not_id
        self.not_kendi = not_kendi
        self.favori = favori
    }
}

