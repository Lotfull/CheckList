//
//  AddChecklistVC.swift
//  Check-list
//
//  Created by Kam Lotfull on 19.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol AddChecklistVCDelegate: class {
    func addChecklistVCDidCancel(_ controller: AddChecklistVC)
    func addChecklistVCDone(_ controller: AddChecklistVC, didFinishAdding list: Checklist)
    func addChecklistVCDone(_ controller: AddChecklistVC, didFinishEditing list: Checklist)
}

class AddChecklistVC: UITableViewController, UITextFieldDelegate, IconPickerVCDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!

    weak var delegate: AddChecklistVCDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.addChecklistVCDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.addChecklistVCDone(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.addChecklistVCDone(self, didFinishAdding: checklist)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon",
        let controller = segue.destination as? IconPickerVC {
            controller.delegate = self
        }
    }
    
    func iconPicker(_ picker: IconPickerVC, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
