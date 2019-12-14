//
//  NotesManager.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 14/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
private let _singletonInstance = NotesManager()
class NotesManager: NSObject {
    var notes = [DBNote]()
    class var sharedInstance: NotesManager {
        return _singletonInstance
    }
    // MARK: - init
    override init() {
        super.init()
        //Initialise all notes from firebase, once only through singleton object
        self.fetchAllPublicNotes()
    }
    func fetchAllPublicNotes()  {
        
    }
    
/*
    func downloadCats(completion: @escaping ([Cat], Error) -> Void) {
       var catArray = [DBNote]()
       let query = dbRef.order(by: "timestamp", descending: true).limit(to: 10)
        query.getDocuments { snapshot, error in
          if let error = error {
            print(error)
            completion(catArray, error)
            return
          }
          for doc in snapshot!.documents {
            let cat = Cat(snapshot: doc)
            catArray.append(cat)
          }
          completion(catArray, nil)
        }
      }
    }
 */
}
