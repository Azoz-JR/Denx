//
//  CoreDataManager.swift
//  MuslimFit
//
//  Created by Karim on 13/08/2023.
//

import Foundation
import CoreData

//@available(iOS 13.0, *)
class CoreDataManager {
    
    private let logEntity = "Adaih"
    
    private var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataManager.self)
        let model = NSManagedObjectModel.mergedModel(from: [bundle])!
        let container = NSPersistentContainer(name: "MuslimFit",managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    lazy var mainManagedContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    //    static var successMessage:String?
    
    func fetchAdaih() -> [Adaih] {
        var logsArr: [Adaih] = []
        let fetchRequest = NSFetchRequest<Adaih>(entityName: logEntity)
        
        mainManagedContext.performAndWait {
            do {
                logsArr = try mainManagedContext.fetch(fetchRequest)
            } catch {
                fatalError("error in fetchLogs \(error)")
            }
        }
        return logsArr
    }
    
    func fetchHesnElmoslem() -> [HesnElmoslem] {
        var logsArr: [HesnElmoslem] = []
        let fetchRequest = NSFetchRequest<HesnElmoslem>(entityName: "HesnElmoslem")
        
        mainManagedContext.performAndWait {
            do {
                logsArr = try mainManagedContext.fetch(fetchRequest)
            } catch {
                fatalError("error in fetchLogs \(error)")
            }
        }
        return logsArr
    }
    
    func fetchQuran() -> [Quran] {
        var logsArr: [Quran] = []
        let fetchRequest = NSFetchRequest<Quran>(entityName: "Quran")
        
        mainManagedContext.performAndWait {
            do {
                logsArr = try mainManagedContext.fetch(fetchRequest)
            } catch {
                fatalError("error in fetchLogs \(error)")
            }
        }
        return logsArr
    }
    
    func saveHesnElmoslem(id: String, header: Data, body: String) {
        
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let log = HesnElmoslem(context: backgroundManagedContext)
            
            log.id = id
            log.header = header
            log.body = body
            
            backgroundManagedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            backgroundManagedContext.insert(log)
            do{
                try backgroundManagedContext.save()
//                NotificationCenter.default.post(name: NSNotification.Name("ReloadData"), object: nil)
            }catch let error{
                fatalError("error in save at coreData: \(error.localizedDescription)")
            }
        }
    }
    
    func saveAdaih(id: String, audio: URL, title: String, played: Bool) {
//        print(id)
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let log = Adaih(context: backgroundManagedContext)
            
            log.id = id
            log.audio = audio
            log.title = title
            log.played = played
            
            backgroundManagedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            backgroundManagedContext.insert(log)
            do{
                try backgroundManagedContext.save()
                NotificationCenter.default.post(name: NSNotification.Name("ReloadData"), object: nil)
            }catch let error{
                fatalError("error in save at coreData: \(error.localizedDescription)")
            }
        }

    }
    
    func saveQuran(id: String, audio: String, name: String) {
//        print(id)
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let log = Quran(context: backgroundManagedContext)
            
            log.id = id
            log.audio = audio
            log.name = name
            
            backgroundManagedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            backgroundManagedContext.insert(log)
            do{
                try backgroundManagedContext.save()
                NotificationCenter.default.post(name: NSNotification.Name("ReloadFetchedQuranData"), object: nil)
            }catch let error{
                fatalError("error in save at coreData: \(error.localizedDescription)")
            }
        }

    }
    
    public func clearAdaihLogs() {
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.logEntity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            backgroundManagedContext.performAndWait {
                do{
                    _ = try backgroundManagedContext.execute(deleteRequest)
                    _ = try backgroundManagedContext.save()
                }catch{
                    fatalError("error in clearLogs at coreData:\(error.localizedDescription)")
                }
            }
        }
    }
    
    public func clearHesnElmoslemLogs() {
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HesnElmoslem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            backgroundManagedContext.performAndWait {
                do{
                    _ = try backgroundManagedContext.execute(deleteRequest)
                    _ = try backgroundManagedContext.save()
                }catch{
                    fatalError("error in clearLogs at coreData:\(error.localizedDescription)")
                }
            }
        }
    }
    
    public func clearQuranLog(at id: String) {
        persistentContainer.performBackgroundTask { backgroundManagedContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quran")
            fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
//
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            backgroundManagedContext.performAndWait {
                do {
//                    _ = try backgroundManagedContext.delete(log)
                    _ = try backgroundManagedContext.execute(deleteRequest)
                    _ = try backgroundManagedContext.save()
                    NotificationCenter.default.post(name: NSNotification.Name("ReloadFetchedQuranData"), object: nil)
                    
                } catch {
                    fatalError("error in clearLogs at coreData:\(error.localizedDescription)")
                }
            }
            
//            backgroundManagedContext.delete(log)
        }
    }
}
