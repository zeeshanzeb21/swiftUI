import Foundation
extension UserDefaults {
    private static let savedLinksKey = "SavedLinks"
    private static let currentIndexKey = "CurrentLinkIndex"


    func getSavedLinks() -> [String] {
        return array(forKey: UserDefaults.savedLinksKey) as? [String] ?? []
    }

    func saveLink(_ link: String) {
        var links = getSavedLinks()
        // Avoid duplicates
        if !links.contains(link) {
            links.append(link)
            set(links, forKey: UserDefaults.savedLinksKey)
        }
    }
    
    func getCurrentLinkIndex() -> Int {
           return integer(forKey: UserDefaults.currentIndexKey)
       }

       func setCurrentLinkIndex(_ index: Int) {
           set(index, forKey: UserDefaults.currentIndexKey)
       }
}
