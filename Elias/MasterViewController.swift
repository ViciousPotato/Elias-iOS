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
  let delegate = UIApplication.shared.delegate as! AppDelegate
  var cameraController: UIImagePickerController?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    let tblView = self.view as! UITableView
    tblView.estimatedRowHeight = 44.0
    tblView.rowHeight = UITableViewAutomaticDimension

    let listImage = UIImage(named: "NavListButton")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(MasterViewController.listButtonTouched))

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MasterViewController.takePhoto(_:)))
    self.navigationItem.rightBarButtonItem = addButton

    self.cameraController = UIImagePickerController()
    
    self.loadBitsInJSON()
  }
  
  func listButtonTouched()
  {
  
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func takePhoto(_ sender: AnyObject) {
    if let c = self.cameraController {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        // TODO: Let user select
        c.sourceType = .camera
      }
      c.mediaTypes = [kUTTypeImage as String]
      c.allowsEditing = true
      c.delegate = self
      
      present(c, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
    let mediaType: AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
    
    if let type: AnyObject = mediaType {
      if type is String {
        let t = type as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if t == (kUTTypeImage as NSString) as String {
          let image = info[UIImagePickerControllerOriginalImage] as? UIImage
          if let i = image {
            // Upload image
            
            delegate.downloadManager!.post(
              Util.imageUploadUrl,
              parameters: nil,
              constructingBodyWith: { (formData : AFMultipartFormData?) -> Void in
                let data = UIImageJPEGRepresentation(image!, Util.imageCompressRate)
                formData?.appendPart(withFileData: data, name: "attach", fileName: "Upload.jpg", mimeType: "image/jpeg")
              },
              success: { (request, response) -> Void in
                print("request : \(request), response: \(response)")

                let jsonResponse = response as! NSDictionary
                let scaledPath = jsonResponse.object(forKey: "scaled") as! String
                self.createBitWithOneImage(scaledPath)

                MBProgressHUD.hide(for: self.view, animated: true)
                picker.dismiss(animated: true, completion: nil)
              },
              failure: { (request, error) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                picker.dismiss(animated: true, completion: nil)

                self.view.makeToast("Error uploading image", duration: 3.0, position: CSToastPositionBottom)
                print("request : \(request), error: \(error)")
              })
          }
        }
      }
    }
  }
  
  func createBitWithOneImage(_ path: String) {
    delegate.downloadManager!.post(Util.createBitUrl, parameters: ["content": "![img](\(path))"],
      constructingBodyWith: nil,
      success: { (request, response) -> Void in
        print("request: \(request) response:\(response)")
      },
      failure: { (request, error) -> Void in
        print("request: \(request) response:\(error)")
      })
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = delegate.bits[indexPath.row] as Bit
        (segue.destination as! DetailViewController).detailItem = object
        }
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return delegate.bits.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let bit = delegate.bits[(indexPath as NSIndexPath).row] as Bit
    var style =  NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    style.alignment = .justified
    style.firstLineHeadIndent = 10.0
    style.headIndent = 10.0
    style.tailIndent = -10.0
    let styleAttr = [NSParagraphStyleAttributeName : style]

    if let cell = tableView.dequeueReusableCell(withIdentifier: "BitSummaryCell") as? BitSummaryCell {
      cell.detailLabel.attributedText = Util.htmlToAttributedString(bit.content, attrs: styleAttr)
      self.setLableShadow(cell.detailLabel)

      return cell
    }
    else {
      let nib = Bundle.main.loadNibNamed("BitSummaryCell", owner: self, options: nil)
      let cell = nib?[0] as! BitSummaryCell

      cell.detailLabel.attributedText = Util.htmlToAttributedString(bit.content, attrs: styleAttr)
      self.setLableShadow(cell.detailLabel)

      return cell
    }
  }
  
  func setLableShadow(_ lbl: UILabel) {
    lbl.backgroundColor = UIColor.white
    
    lbl.layer.borderColor = Util.UIColorFromHex(0xd8d8d8).cgColor
    lbl.layer.borderWidth = 1
    // TODO ?
    lbl.layer.frame = CGRect(x: -1, y: lbl.layer.frame.size.height-1, width: lbl.layer.frame.size.width, height: lbl.layer.frame.size.height)
    
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          delegate.bits.remove(at: (indexPath as NSIndexPath).row)
          tableView.deleteRows(at: [indexPath], with: .fade)
      } else if editingStyle == .insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
      }
  }
  
  func loadBitsInJSON() -> Bool {
    let requestURL = Util.initLoadUrl
    delegate.downloadManager?.get(requestURL, parameters: nil,
      success: { (operation, response)-> Void in
        let responseDic = response as! NSDictionary
        let responseArr = responseDic.object(forKey: "bits") as! NSArray
        for bit in responseArr {
          self.delegate.bits.append(Bit.fromJSONDic(bit as! NSDictionary))
        }
        (self.view as! UITableView).reloadData()
      }, failure: {(operation, error)-> Void in
        print(error)
    })
    return true
  }
}

