//
//  MenuItem.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/7/23.
//

import UIKit

struct MenuItem {
    var foodID: Int
    var title: String
    var calories: Int
    var icons: [String]
    var rating: CGFloat
    var nutritionData: [String: String]
    var ingredients: String
    var contains: [String]
}
