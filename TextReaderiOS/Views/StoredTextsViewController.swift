//
//  StoredTextsViewController.swift
//  TextReaderiOS
//
//  Created by Darién on 5/11/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit

class StoredTextsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchText: UISearchBar!
    
    var selectedText:String?
    var textList:Array<SavedText> = Array<SavedText>()
    var savedTextViewModel = SavedTextsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        savedTextViewModel.delegate = self
        let cellView = UINib(nibName: "SavedTextCell", bundle: nil)
        table.register(cellView, forCellReuseIdentifier: "SavedTextCell")
        savedTextViewModel.requestTexts(query: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReadTextViewController{
            let destinationVC = segue.destination as? ReadTextViewController
            if let text = selectedText{
                destinationVC?.text = text
                destinationVC?.canAdd = false
            }
        }
    }
    
    func showReadText(){
        self.performSegue(withIdentifier: "ReadTextSegue", sender: self)
    }
}

extension StoredTextsViewController:SavedTextsChangedDelegate{
    func onTextListChange(_ savedTextsViewModel: SavedTextsViewModel, textList: Array<SavedText>) {
        self.textList = textList
        table.reloadData()
    }
}

extension StoredTextsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTextCell", for: indexPath) as! SavedTextCell
        cell.setupData(text: textList[indexPath.row].text!, timestamp: textList[indexPath.row].timestamp!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedText = textList[indexPath.row].text
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ReadTextSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedTextViewModel.deleteText(text: textList[indexPath.row].text!, searchQuery: searchText.text!)
        }
    }
}

extension StoredTextsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        savedTextViewModel.requestTexts(query: searchText)
    }
}
