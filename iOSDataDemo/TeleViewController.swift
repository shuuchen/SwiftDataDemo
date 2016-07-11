//
//  TeleViewController.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/17.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class TeleViewController: UIViewController {

    var picker: CNContactPickerViewController!
    
    let displayedItems = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = displayedItems
       
        presentViewController(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TeleViewController: CNContactPickerDelegate {
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        
        let contactName = CNContactFormatter.stringFromContact(contact, style: .FullName)
        let propertyName = CNContact.localizedStringForKey(contactProperty.key)
        
        let title = "\(contactName)'s \(propertyName)"
        
        dispatch_async(dispatch_get_main_queue(), {
        
            let alert = UIAlertController(title: title, message: contactProperty.value?.description, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        
        
    }
}