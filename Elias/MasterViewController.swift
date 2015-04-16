//
//  MasterViewController.swift
//  Elias
//
//  Created by zhou on 7/1/15.
//  Copyright (c) 2015 zhou. All rights reserved.
//

import UIKit
import MobileCoreServices

class MasterViewController:
  UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    var cameraController: UIImagePickerController?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "takePhoto:")
        self.navigationItem.rightBarButtonItem = addButton
    
        self.cameraController = UIImagePickerController()
        if let c = self.cameraController {
          // c.sourceType = .Camera
          c.mediaTypes = [kUTTypeImage as String]
          c.allowsEditing = true
          c.delegate = self
        }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func takePhoto(sender: AnyObject) {
        presentViewController(self.cameraController!, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = delegate.bits[indexPath.row] as Bit
            (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.bits.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = delegate.bits[indexPath.row] as Bit
        cell.textLabel.text = object.content
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            delegate.bits.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

