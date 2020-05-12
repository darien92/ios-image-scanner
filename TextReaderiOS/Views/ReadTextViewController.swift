//
//  ReadTextViewController.swift
//  TextReaderiOS
//
//  Created by Darién on 5/8/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit

class ReadTextViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    var text:String?
    var canAdd:Bool?
    private var saveTextRepo:SaveTextRepo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let textFetched = text else{
            return
        }
        textView.text = textFetched
        guard let canAddFetched = canAdd else {
            return
        }
        if !canAddFetched{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        saveTextRepo = SaveTextRepo()
        saveTextRepo.saveText(text: text!)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
