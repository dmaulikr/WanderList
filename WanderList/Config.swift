//
//  Config.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Configuration file
//

import UIKit

class Config: NSObject {

    // Mark: Category Color
    static let colors: [UIColor] = [
        UIColor.blackColor(),
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.cyanColor(),
        UIColor.yellowColor(),
        UIColor.magentaColor(),
        UIColor.orangeColor(),
        UIColor.purpleColor(),
        UIColor.brownColor()
    ]
    static let colorsText: [String] = ["Black", "Red", "Green", "Blue", "Cyan", "Yellow", "Magenta", "Orange", "Purple", "Brown"]

    // Mark: Notification Radius
    static let radius: [Int] = [50, 250, 1000]
    static let radiusText: [String] = ["50 metres", "250 metres", "1 kilometer"]
}
