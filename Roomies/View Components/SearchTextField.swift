//
//  SearchTextField.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

@objc public class SearchSuggestion: NSObject {
    var title: String
    var subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}

@objc public protocol SearchTextFieldDelegate {
    func dataForPopoverInTextField(_ textfield: SearchTextField) -> [SearchSuggestion]

    @objc optional func textFieldDidEndEditing(_ textField: SearchTextField, withSelection data: SearchSuggestion)
    @objc optional func textFieldShouldSelect(_ textField: SearchTextField) -> Bool
}

private var tableViewController: UITableViewController?
private var data = [SearchSuggestion]()
private var filteredData = [SearchSuggestion]()

@IBDesignable public class SearchTextField: UITextField, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    // Set this to override the default corner radius of the textfield
    @IBInspectable var cornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(self.cornerRadius)
        }
    }

    //Set this to override the default color of suggestions popover. The default color is [UIColor colorWithWhite:0.99 alpha:0.99]
    @IBInspectable var popoverBackgroundColor: UIColor = UIColor(white: 1, alpha: 0.97)

    //Set this to override the default frame of the suggestions popover that will contain the suggestions pertaining to the search query. The default frame will be of the same width as textfield, of height 200px and be just below the textfield.
    @IBInspectable var popoverSize: CGRect = CGRect(x: 0, y: 0, width: 300, height: 300)

    //Set this to override the default seperator color for tableView in search results. The default color is light gray.
    @IBInspectable var seperatorColor: UIColor = UIColor(white: 0.50, alpha: 0.25)

    var searchDelegate: SearchTextFieldDelegate?
    var index = Int()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let str: String = self.text!
        if (str.count > 0) && (self.isFirstResponder) {
            if (self.searchDelegate != nil) {
                data = self.searchDelegate!.dataForPopoverInTextField(self)
                self.provideSuggestions()
            } else {
                print("<SearchTextField> WARNING: You have not implemented the required methods of the SearchTextField protocol.")
            }
        } else {
            if let table = tableViewController {
                if table.tableView.superview != nil {
                    table.tableView.removeFromSuperview()
                    tableViewController = nil
                }
            }
        }
    }

    override public func resignFirstResponder() -> Bool {
        if tableViewController != nil {
            UIView.animate(withDuration: 0.3,
                animations: ({
                    tableViewController!.tableView.alpha = 0.0
                }),
                completion: {
                    (finished: Bool) in
                    if tableViewController != nil {
                        tableViewController!.tableView.removeFromSuperview()
                        tableViewController = nil
                    }
                })
            self.handleExit()
        }

        return super.resignFirstResponder()
    }

    func provideSuggestions() {
        self.applyFilterWithSearchQuery(self.text!)
        if let _ = tableViewController {
            tableViewController!.tableView.reloadData()
        } else if filteredData.count > 0 {
            //Add a tap gesture recogniser to dismiss the suggestions view when the user taps outside the suggestions view
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.cancelsTouchesInView = false
            tapRecognizer.delegate = self
            self.superview!.addGestureRecognizer(tapRecognizer)

            tableViewController = UITableViewController()
            tableViewController!.tableView.delegate = self
            tableViewController!.tableView.dataSource = self
            tableViewController!.tableView.backgroundColor = self.popoverBackgroundColor
            tableViewController!.tableView.separatorColor = self.seperatorColor

            if self.popoverSize != CGRect.zero {
                tableViewController!.tableView.frame = self.popoverSize
            } else {
                //PopoverSize frame has not been set. Use default parameters instead.
                var frameForPresentation = self.frame
                frameForPresentation.origin.y += self.frame.size.height
                frameForPresentation.size.height = 200
                tableViewController!.tableView.frame = frameForPresentation
            }

            // Show table view on top of other subviews
            let aView = tableViewController!.tableView
            var frame = aView?.frame

            frame!.origin = self.superview!.convert((frame?.origin)!, to: nil)
            aView?.frame = frame!

            self.window!.addSubview(aView!)

            // Animate table view appearance
            tableViewController!.tableView.alpha = 0.0
            UIView.animate(withDuration: 0.3,
                animations: ({
                    tableViewController!.tableView.alpha = 1.0
                }),
                completion: {
                    (finished: Bool) in

                })
        }

    }

    @objc func tapped (_ sender: UIGestureRecognizer!) {
        if let table = tableViewController {
            if !table.tableView.frame.contains(sender.location(in: self.superview)) && self.isFirstResponder {
                let _ = self.resignFirstResponder()
            }
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredData.count
        if count == 0 {
            UIView.animate(withDuration: 0.3,
                animations: ({
                    tableViewController!.tableView.alpha = 0.0
                }),
                completion: {
                    (finished: Bool) in
                    if let table = tableViewController {
                        table.tableView.removeFromSuperview()
                        tableViewController = nil
                    }
                })
        }
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "resultsCell")
        }
        // Customize separator width
        tableView.separatorInset = UIEdgeInsets.zero
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        cell?.preservesSuperviewLayoutMargins = false
        // Customize cells
        cell?.backgroundColor = UIColor.clear
        let dataForRowAtIndexPath = filteredData[indexPath.row]
        let displayText = dataForRowAtIndexPath.title
        cell?.textLabel!.text = displayText
        cell?.textLabel!.font = cell!.textLabel?.font.withSize(15)
        cell?.textLabel?.textColor = UIColor.darkText
        if let displaySubText = dataForRowAtIndexPath.subtitle {
            cell?.detailTextLabel!.text = displaySubText
            cell?.detailTextLabel?.textColor = UIColor.gray
        }

        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        let _ = self.resignFirstResponder()
    }


    // Mark: Filter Method

    func applyFilterWithSearchQuery(_ filter: String) -> Void {
        let matchingData = data.filter({

            return $0.title.lowercased().hasPrefix((filter as NSString).lowercased)
        })

        filteredData = matchingData
    }

    func handleExit() {
        if let table = tableViewController {
            table.tableView.removeFromSuperview()
        }
        if ((searchDelegate?.textFieldShouldSelect?(self)) != nil) {
            if filteredData.count > 0 {
                let selectedData = filteredData[self.index]
                let displayText = selectedData.title
                self.text = displayText
                searchDelegate?.textFieldDidEndEditing?(self, withSelection: selectedData)
            } else {
                searchDelegate?.textFieldDidEndEditing?(self, withSelection: SearchSuggestion(title: self.text ?? ""))
            }
        }

    }

}
