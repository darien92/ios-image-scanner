import Foundation

struct SavedTextsViewModel {
    var delegate:SavedTextsChangedDelegate?
    var saveTextRepo:SaveTextRepo
    
    var textsList:Array<SavedText>{
        didSet{
            delegate?.onTextListChange(self, textList: textsList)
        }
    }
    
    init() {
        textsList = Array<SavedText>()
        saveTextRepo = SaveTextRepo()
    }
    
    mutating func requestTexts(query:String){
        if let elemetns = saveTextRepo.getElemet(query: query){
            textsList = elemetns
        }
    }
    
    mutating func deleteText(text:String, searchQuery:String){
        var index = 0
        for currTextElement in textsList{
            if currTextElement.text! == text {
                break
            }
            index += 1
        }
        saveTextRepo.deleteSelectedItem(index: index, items: &textsList)
        if let element = saveTextRepo.getElemet(query: searchQuery){
            textsList = element
        }
    }
}

protocol SavedTextsChangedDelegate {
    func onTextListChange(_ savedTextsViewModel:SavedTextsViewModel, textList:Array<SavedText>)
}
