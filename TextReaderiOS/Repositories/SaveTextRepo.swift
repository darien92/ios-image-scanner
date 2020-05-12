//
//  SaveTextRepo.swift
//  TextReaderiOS
//
//  Created by Darién on 5/11/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit
import CoreData

struct SaveTextRepo {
    var context: NSManagedObjectContext
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    func saveText(text:String){
        let newItem = SavedText(context:context) //recordar que la entidad se llama Item
        newItem.text = text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let currDate = Date()
        newItem.timestamp = dateFormatter.string(from: currDate)
        saveContext()
    }
    
    func deleteSelectedItem(index:Int, items:inout Array<SavedText>) {
        items.remove(at: index)
        context.delete(items[index])
        saveContext()
    }
    
    func getElemet(query:String) -> Array<SavedText>?{
        let request: NSFetchRequest<SavedText> = SavedText.fetchRequest()
        if query.count > 0 { //looking for query if text is not empty
            let predicate = NSPredicate(format: "text CONTAINS[cd] %@", query)
            request.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true) //lo que quiero que me devuelva y en que formato
        request.sortDescriptors = [sortDescriptor]
        return fetchItemsFromRequest(request: request)
    }
    
    func saveContext(){
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadItems() -> Array<SavedText>?{
        let request:NSFetchRequest<SavedText> = SavedText.fetchRequest()
        do {
            let textArray = try context.fetch(request)
            return textArray
        } catch {
            return nil
        }
    }
    
    func fetchItemsFromRequest(request:NSFetchRequest<SavedText>) -> Array<SavedText>? {
        do {
            let textArray = try context.fetch(request)
            return textArray
        } catch {
            return nil
        }
    }
}
