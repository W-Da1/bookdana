//
//  BookDetailViewController.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/26.
//

import UIKit

class BookSubscribeViewController: UIViewController {

    var bookName: String?

    @IBOutlet weak var bookInformation: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //画面が遷移された時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        // Do any additional setup after loading the view.
        if let bn = self.bookName {
            self.bookInformation.text = bn
            self.navigationItem.title = "Edit Book Information"
        }
        let text = self.bookInformation.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        let text = self.bookInformation.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let saveButton = sender as? UIBarButtonItem, saveButton === self.saveButton else {
            return
        }
        self.bookName = self.bookInformation.text ?? ""
        /*
        guard let identifier = segue.identifier else {
            return
        }
        guard let readerButton = sender as? UIBarButtonItem, readerButton === self.readerButton else {
            if identifier == "readerISBN" {
                let bookInformationVC = segue.destination as! CaptureViewController
        }
        */
    }

}
