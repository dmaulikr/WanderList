//
//  ReminderCategoryMapMasterController.swift
//  WanderList
//
//  Created by HaoBoji on 6/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class ReminderCategoryMapMasterController: UIViewController, CategoryListDelegate {

    var categories: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController!.toolbarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.title = "Categories"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        categories = DataManager.shared.getCategoryList()
    }

    // MARK: - Segues, Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "listSegue") {
            let mapController = self.storyboard!.instantiateViewControllerWithIdentifier("ReminderCategoryMasterController") as! ReminderCategoryMasterController
            UIView.beginAnimations("animation", context: nil)
            UIView.setAnimationDuration(1.0)
            self.navigationController!.pushViewController(mapController, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
            UIView.commitAnimations()
            return false
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "addCategory":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            break
        default:
            break
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation

     */

}
