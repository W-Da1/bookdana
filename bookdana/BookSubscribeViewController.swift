//
//  BookDetailViewController.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/26.
//

import UIKit

class BookSubscribeViewController: UIViewController, UITextFieldDelegate {

    var bookInformation: Book?

    @IBOutlet weak var bookISBN: UITextField!
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var bookPublishDate: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    //画面が遷移された時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        // Do any additional setup after loading the view.
        if self.bookInformation?.title != nil {
            self.navigationItem.title = "Edit Book Information"
        }
        let text = self.bookInformation?.title ?? ""
        if bookInformation != nil {
            self.bookTitle.text = bookInformation?.title
            self.bookPublishDate.text = bookInformation?.publishDate
            self.bookAuthor.text = bookInformation?.author
        }
        self.saveButton.isEnabled = !text.isEmpty
        self.bookISBN.delegate = self
        self.bookTitle.delegate = self
        self.bookPublishDate.delegate = self
        self.bookAuthor.delegate = self
    }
    
    @IBAction func titleTextFieldChaned(_ sender: Any) {
        let text = self.bookTitle.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }

    @IBAction func ISBNSearch(_ sender: Any) {
        Task { @MainActor in
            if bookISBN.text != nil {
                let api = GoogleBookAPI(ISBN: bookISBN.text!)
                let book = try await api.getBookData()
                self.bookInformation = book
                self.bookTitle.text = bookInformation?.title
                self.bookPublishDate.text = bookInformation?.publishDate
                self.bookAuthor.text = bookInformation?.author
                self.saveButton.isEnabled = true
            }
        }
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
        var book: Book = Book()
        book.title = self.bookTitle.text ?? "タイトル"
        book.publishDate = self.bookPublishDate.text ?? "未設定"
        book.author = self.bookAuthor.text ?? "未設定"
        self.bookInformation = book
    }
    
    @IBAction func unwindToBarcodeReader(segue: UIStoryboardSegue) {
        if let captureVC = segue.source as? CaptureViewController {
            self.bookISBN.text = captureVC.ISBN
        }
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        //キーボードをしまう
        textField.resignFirstResponder()
        return false
    }

}
