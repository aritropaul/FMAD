//
//  ListViewController.swift
//  FMAD
//
//  Created by Aritro Paul on 22/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var nameList = [String]()
    var listOfAddresses =  [String]()
    var tableCount = 1;
    var pricePerDesk = 1;
    var timeSelected = "11 : 00 AM"
    var tagPressed  = Int()
    func checkTableCount() {
        if tableCount == 1{
            DecreaseButton.isUserInteractionEnabled = false
            DecreaseButton.backgroundColor = UIColor.lightGray
        }
        else {
            DecreaseButton.isUserInteractionEnabled = true
            DecreaseButton.backgroundColor = UIColor.red
        }
    }
    @IBAction func minusTapped(_ sender: Any) {
        checkTableCount()
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var DecreaseButton: UIButton!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    
    @IBAction func donePressed(_ sender: Any) {
        let dateFormatter = DateFormatter()
        timePicker.datePickerMode = .time
        dateFormatter.dateFormat = "hh : mm a"
        timeSelected = dateFormatter.string(from: timePicker.date)
        print(timeSelected)
        UIView.animate(withDuration: 0.4) {
            self.timePickerView.frame = CGRect(x: self.timePickerView.frame.origin.x, y: 667, width: self.timePickerView.frame.width, height: self.timePickerView.frame.height)
        }
        changeLabel(tag: tagPressed)
    }
    
    @objc func num(_ sender:AnyObject){
        let tag = sender.view.tag
        if tag == 2 {
            let alert = UIAlertController(title: "Desks to List", message: nil , preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
                let numDesks = alert.textFields![0] as UITextField
                numDesks.keyboardType = UIKeyboardType.numberPad
                if numDesks.text != "" {
                    self.tableCount = Int(numDesks.text!)!
                    self.tableLabel.text = numDesks.text
                    self.checkTableCount()
                }
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Enter Number of Desks"
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
        else if tag == 3 {
            getAddress()
        }
        else if tag == 4{
            let alert = UIAlertController(title: "Price per Desk", message: nil , preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
                let price = alert.textFields![0] as UITextField
                price.keyboardType = UIKeyboardType.numberPad
                if price.text != "" {
                    self.pricePerDesk = Int(price.text!)!
                    self.priceLabel.text = price.text
                    self.totalPrice.text = "$ \(self.tableCount*7)"
                }
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Enter Price per Desk"
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @objc func time(_ sender: AnyObject){
        let tag = sender.view.tag
        UIView.animate(withDuration: 0.4) {
            self.timePickerView.frame = CGRect(x: self.timePickerView.frame.origin.x, y: 667-194, width: self.timePickerView.frame.width, height: self.timePickerView.frame.height)
        }
        print(tag)
        tagPressed = tag
    }
    
    func getAddress(){
        let alert = UIAlertController(title: "Enter Address", message: nil , preferredStyle: .alert)
        let action = UIAlertAction(title: "Address", style: .default) { (alertAction) in
            let nameOfPlace = alert.textFields![0] as UITextField
            let addressField = alert.textFields![1] as UITextField
            
            if nameOfPlace.text != "" && addressField.text != ""{
                self.nameList.append(nameOfPlace.text!)
                self.listOfAddresses.append(addressField.text!)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Address"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    func changeLabel(tag: Int){
        if tag == fromTimeLabel.tag{
            fromTimeLabel.text = timeSelected
        }
        else if tag == toTimeLabel.tag{
            toTimeLabel.text = timeSelected
        }
    }
    
    func setup(){
        let fromtimeTapped = UITapGestureRecognizer(target: self, action: #selector(time))
        fromtimeTapped.numberOfTapsRequired = 1
        let totimeTapped = UITapGestureRecognizer(target: self, action: #selector(time))
        let tableTapped = UITapGestureRecognizer(target: self, action: #selector(num(_:)))
        let priceTapped = UITapGestureRecognizer(target: self, action: #selector(num(_:)))
        tableTapped.numberOfTapsRequired = 1
        priceTapped.numberOfTapsRequired = 1
        totimeTapped.numberOfTapsRequired = 1
        fromTimeLabel.tag = 0
        toTimeLabel.tag = 1
        view1.tag = 2
        view2.tag = 3
        view3.tag = 4
        fromTimeLabel.isUserInteractionEnabled = true
        fromTimeLabel.addGestureRecognizer(fromtimeTapped)
        toTimeLabel.isUserInteractionEnabled = true
        toTimeLabel.addGestureRecognizer(totimeTapped)
        view1.isUserInteractionEnabled = true
        view3.isUserInteractionEnabled = true
        view1.addGestureRecognizer(tableTapped)
        view3.addGestureRecognizer(priceTapped)
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.lightGray.cgColor
        view1.layer.cornerRadius = 8
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.lightGray.cgColor
        view2.layer.cornerRadius = 8
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.lightGray.cgColor
        view3.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        checkTableCount()
        // Do any additional setup after loading the view.
    }
    
}
