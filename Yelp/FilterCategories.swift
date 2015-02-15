//
//  FilterCategories.swift
//  Yelp
//
//  Created by Hao Sun on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

class FilterCategories: NSObject {
    var resturantsCategories = NSMutableDictionary()
    
    override init() {
        resturantsCategories["Afghan"] = "afghani"
        resturantsCategories["African"] = "african"
        resturantsCategories["Senegalese"] = "senegalese"
        resturantsCategories["South African"] = "southafrican"
        resturantsCategories["American (New)"] = "newamerican"
        resturantsCategories["American (Traditional)"] = "tradamerican"
        resturantsCategories["Arabian"] = "arabian"
        resturantsCategories["Arab Pizza"] = "arabpizza"
        resturantsCategories["Argentine"] = "argentine"
        resturantsCategories["Armenian"] = "armenian"
        resturantsCategories["Asian Fusion"] = "asianfusion"
        resturantsCategories["Asturian"] = "asturian"
        resturantsCategories["Australian"] = "australian"
        resturantsCategories["Austrian"] = "austrian"
        resturantsCategories["Baguettes"] = "baguettes"
        resturantsCategories["Bangladeshi"] = "bangladeshi"
        resturantsCategories["Barbeque"] = "bbq"
        resturantsCategories["Basque"] = "basque"
        resturantsCategories["Bavarian"] = "bavarian"
        resturantsCategories["Beer Garden"] = "beergarden"
    }
    
    func allResturants() -> [String] {
        return resturantsCategories.allKeys as [String]
    }
}