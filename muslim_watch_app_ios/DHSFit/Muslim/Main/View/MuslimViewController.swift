//
//  MuslimViewController.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import UIKit
//import HomeFeature
import AppStructureFeature
import NoorFont
import Logging
import NoorUI

class MuslimViewController: UIViewController {
    
    //    lazy var containerView = MuslimContainerView()
    
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    let muslimWorker: MuslimWorkerProtocol = MuslimWorker()
    var localTimeZoneIdentifier: String {
        return TimeZone.current.identifier
    }
    
    let locationDelegate = LocationDelegate()
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
//    var locationManager = CLLocationManager()
    
    var latestLocation: CLLocation? = nil
    
    var city = ""
    
    let coreDataManager = CoreDataManager()
    
    let container = Container.shared
//    let downloadManagerContainer = DownloadManagerContainer.shared
    
    lazy var containerView: MuslimContainerView = {
        var view = MuslimContainerView(view: self)
        return view
    }()
    
    
    var language: String {
        switch LanguageManager.shareInstance().getHttpLanguageType() {
        case "ar":
            return "arabic"
        case "en":
            return "english"
        case "fr":
            return "french"
//        case "de":
//            return "german"
//        case "el":
//            return "greece"
        case "es":
            return "spanish"
//        case "fa":
//            return "persian"
//        case "he":
//            return "hebrew"
        case "id":
            return "indonesian"
//        case "it":
//            return "italy"
//        case "pl":
//            return "poland"
//        case "pt":
//            return "portugal"
        case "ru":
            return "russian"
        case "tr":
            return "turkish"
        case "ur":
            return "urdo"
//        case "vi":
//            return "vietnam"
        default:
            return "arabic"
        }
    }
    
    func getAdaih(lang: String) {
        
//        self.coreDataManager.clearLogs()
        
        muslimWorker.adaih(lang) { result in
            switch result {
            case let .success(responseModel):
//                self.containerView.adaih = responseModel?.data ?? []
                UserDefaults.standard.set(responseModel?.count, forKey: "adaihCount")
                for i in responseModel ?? [] {
                    
                    guard let url = URL(string: "\(i.url ?? "")") else {
                            return
                        }
                    
//                    guard let data = try? Data(contentsOf: url) else { return }
//                    print(i.id)
                    
//                    self.coreDataManager.saveAdaih(id: "\(i.id ?? 0)", audio: url, title: i.title ?? "", played: i.played ?? false)
                    
//                    guard let audioURL = URL(string: url) else {
//                        print("Invalid audio URL")
//                        return
//                    }

//                    DispatchQueue.global().async {
                        self.downloadAudio(url: url) { (destinationURL) in
                            if let destinationURL = destinationURL {
                                // File downloaded successfully, use the destinationURL for offline playback
    //                            UserDefaults.standard.setValue(destinationURL, forKey: "url")
                                print(destinationURL)
    //                            self.containerView.urls.append(destinationURL)
//                                DispatchQueue.main.async {
                                self.coreDataManager.saveAdaih(id: "\(i.id ?? 0)", audio: destinationURL, title: i.title ?? "", played: i.played ?? false)
//                                }
//                                NotificationCenter.default.post(name: NSNotification.Name("ReloadData"), object: nil)
                            } else {
                                // File download failed
                                print("failed to download")
                                
                            }
                        }
//                    }
                    
                }
                
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.adaih, value: responseModel)
                
                
//                self.containerView.adaihTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func downloadAudio(url: URL, completion: @escaping (URL?) -> Void) {
        let session = URLSession(configuration: .default)
        let downloadTask = session.downloadTask(with: url) { (location, _, error) in
            guard let location = location, error == nil else {
                print("Failed to download audio file:", error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            print(location)
            
            print("\(location)")
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let destinationURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(url.lastPathComponent)
            
            
            do {
                
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                    
                }
                try FileManager.default.moveItem(at: location, to: destinationURL)
                print("Downloaded audio file:", destinationURL.path)
                completion(destinationURL)
            } catch {
                print("Failed to move audio file to destination:", error.localizedDescription)
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
    
    func hesnElmoslem(lang: String) {
        muslimWorker.hesnElmoslem(lang) { result in
            switch result {
            case let .success(responseModel):
//                self.containerView.hesnElmoslem = responseModel?.data ?? []
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.hesnElmoslem, value: responseModel)
                
                for i in responseModel ?? [] {
                    
                    guard let headerUrl = URL(string: "\(i.header ?? "")") else {
                            return
                        }
                    DispatchQueue.global().async {
                        guard let headerData = try? Data(contentsOf: headerUrl) else {
                            return
                        }
                        self.coreDataManager.saveHesnElmoslem(id: "\(i.id ?? 0)", header: headerData, body: i.body ?? "")
                    }
                    
                    
                    
//                    }
                    
                }
                
//                self.containerView.HesnElmoslemTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func get_locationAddress(location:CLLocationCoordinate2D, completion: @escaping ((String) -> Void)) {
        var ccc = ""
        let geoCoder = CLGeocoder()
        let addressLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(addressLocation, preferredLocale: NSLocale(localeIdentifier: LanguageManager.shareInstance().getHttpLanguageType()) as Locale, completionHandler: { (placemarks, error) -> Void in
            
            if let placeMark = placemarks?[0]{
                
//                self.city = placeMark.locality?.lowercased() ?? ""
                ccc = placeMark.locality ?? ""
                
                print("city:", ccc)
                
//                self.locationManager.stopUpdatingLocation()
                completion(ccc)
                
//                self.mapAddress = "\(Location_name) \(Street)\(State) \(Zip)\(City)\(Country)"
//                userDefaults.set(self.mapAddress, forKey: "mapAddress")
//                return City
            }
            
//            return ""
        })
//        locationManager.stopUpdatingLocation()
//        print(ccc)
//        completion(ccc)
//        return city.lowercased()
    }
    
//    func LocationRequest() {
//        self.locationManager = CLLocationManager()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        if CLLocationManager.locationServicesEnabled(){
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//
//        }else{
//            locationManager.startUpdatingLocation()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.backgroundColor = .red
        
        
//        coreDataManager.clearLogs()
//        hesnElmoslem(lang: language)
        
//        locationManager.delegate = self
        locationManager.delegate = locationDelegate
        
        locationDelegate.locationCallback = { [weak self] location in
            guard let self = self else { return }
//            getPrayersTime(zone: get_locationAddress(location: location.coordinate))
//            get_locationAddress(location: location.coordinate)
//            getPrayersTime(zone: get_locationAddress(location: location.coordinate))
//            get_locationAddress(location: location.coordinate) { [weak self] city in
//                guard let self = self else { return }
//                print(city)
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [weak self] in
//                    guard let self = self else { return }
                
//                getPrayersTime(zone: "riyadh")
                
//            print(Date())
            let date = Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            
                getPrayersTime(date: "\(day)-\(month)-\(year)", lat: "\(location.coordinate.latitude)", lng: "\(location.coordinate.longitude)")
//                }
//            }
            locationManager.stopUpdatingLocation()
        }
        
        UserDefaults.standard.setValue(language, forKey: "deviceLang")
        
        getAdaih(lang: language)
        
        // Do any additional setup after loading the view.
        containerView.muslimTableView.reloadData()
        
//        getPrayersTime(zone: localTimeZoneIdentifier.components(separatedBy: "/")[1])
        
//        DispatchQueue.global().async { [weak self] in
//            guard let self = self else { return }
//            get_locationAddress(location: latestLocation?.coordinate ?? CLLocationCoordinate2D())
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [weak self] in
//            guard let self = self else { return }
        
        
        
//            getPrayersTime(zone: city)
        
        
        
//        }
        
//        FontName.registerFonts()
//        LoggingSystem.bootstrap(StreamLogHandler.standardError)
//        AsyncTextLabelSystem.bootstrap(FixedTextNode.init)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSDK), name: NSNotification.Name("DismissSDK"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerFont), name: NSNotification.Name("RegisterFont"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearCoreData), name: NSNotification.Name("ClearCoreData"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("TestNotification"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("ClearCore"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(registerFont), name: NSNotification.Name("NotificationCenter"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
    @objc func registerFont() {
//        print("\n\n\nRegisterFont\n\n\n")
        
        print("font flag:", UserDefaults.standard.value(forKey: "fontFlag"))
        
        if (UserDefaults.standard.value(forKey: "fontFlag") == nil) {
            FontName.registerFonts()
            LoggingSystem.bootstrap(StreamLogHandler.standardError)
//            AsyncTextLabelSystem.bootstrap(FixedTextNode.init)
        }
        
//        Task {
//            let _ = await downloadManagerContainer.downloadManager()
//        }
////
////            // Begin fetching resources immediately upon the application's start-up.
//        Task { await container.readingResources.startLoadingResources() }
        
        Task {
            // Eagerly load download manager to handle any background downloads.
            await container.downloadManager.start()

            // Begin fetching resources immediately after download manager is initialized.
            await container.readingResources.startLoadingResources()
        }
    }
    
    @objc func clearCoreData() {
//        print("RegisterFont")
        coreDataManager.clearAdaihLogs()
        coreDataManager.clearHesnElmoslemLogs()
    }
    
    @objc func dismissSDK() {
        print("dismissed")
        
        print(DHBleCommandTypeAppStatusControl.rawValue)
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sd = (scene?.delegate as? SceneDelegate) {
            //            sd.window.overrideUserInterfaceStyle = ThemeService.shared.theme.userInterfaceStyle
            //                self.sd = window
            
            //                let navigation = UINavigationController()
            
            //            let launchBuilder = LaunchBuilder(container: Container.shared)
            //            let launchStartup = launchBuilder.launchStartup()
            //            launchStartup.launch(from: sd.window)
            //
            //            self.launchStartup = launchStartup
            
//            switch (DHAppStatus) {
            switch ConfigureModel.shareInstance().appStatus {
            case 0:
//                    LaunchViewController *vc = [[LaunchViewController alloc] init];
//                    vc.isHideNavigationView = YES;
//                    UINavigationController *launchVC = [[UINavigationController alloc] initWithRootViewController:vc];
//                    [self.window setRootViewController:launchVC];
                    
                    let vc = LaunchViewController()
                    vc.isHideNavigationView = true
                    let launchVC = UINavigationController(rootViewController: vc)
                    sd.window.rootViewController = launchVC
                break
            case 1:
//                    SignHomeViewController *vc = [[SignHomeViewController alloc] init];
//                    vc.isHideNavigationView = YES;
//                    UINavigationController *launchVC = [[UINavigationController alloc] initWithRootViewController:vc];
//                    [self.window setRootViewController:launchVC];
                    
                    let vc = SignHomeViewController()
                    vc.isHideNavigationView = true
                    let launchVC = UINavigationController(rootViewController: vc)
                    sd.window.rootViewController = launchVC
                    
                break
            default:
//                    RootTabBarController *rootVC = [[RootTabBarController alloc] init];
//                    [self.window setRootViewController:rootVC];
                    
                    let rootVC = RootTabBarController()
//                    vc.isHideNavigationView = true
//                    let launchVC = UINavigationController(rootViewController: vc)
                    sd.window.rootViewController = rootVC
                    
                break
            }
            
            
//            let window = UIWindow(windowScene: sd.window)
//            sd.window.rootViewController = MyRootViewController()
//            sd.window = window
            sd.window.makeKeyAndVisible()
        }
        
    }
    
    func getPrayersTime(date: String, lat: String, lng: String) {

        muslimWorker.prayerTimes(date, lat, lng) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(responseModel):
//                self.containerView.today = responseModel?.today
//                UserDefaults.standard.set(responseModel?.today, forKey: "prayerTimes")
//                print(responseModel)
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.prayerTimes, value: responseModel)
                                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "H:mm"
                let fajr24 = dateFormatter.date(from: responseModel?.data?.timings?.fajr ?? "") ?? Date()

                dateFormatter.dateFormat = "h:mm a"
                let fajr12 = dateFormatter.string(from: fajr24)
                
                dateFormatter.dateFormat = "H:mm"
            let dhuhr24 = dateFormatter.date(from: responseModel?.data?.timings?.dhuhr ?? "") ?? Date()

                dateFormatter.dateFormat = "h:mm a"
            let dhuhr12 = dateFormatter.string(from: dhuhr24)
                    dateFormatter.dateFormat = "H:mm"
                let asr24 = dateFormatter.date(from: responseModel?.data?.timings?.asr ?? "") ?? Date()

                    dateFormatter.dateFormat = "h:mm a"
                let asr12 = dateFormatter.string(from: asr24)
                
                dateFormatter.dateFormat = "H:mm"
            let maghrib24 = dateFormatter.date(from: responseModel?.data?.timings?.maghrib ?? "") ?? Date()

                dateFormatter.dateFormat = "h:mm a"
            let maghrib12 = dateFormatter.string(from: maghrib24)
                
                dateFormatter.dateFormat = "H:mm"
                let ishaa24 = dateFormatter.date(from: responseModel?.data?.timings?.isha ?? "") ?? Date()

                dateFormatter.dateFormat = "h:mm a"
            let ishaa12 = dateFormatter.string(from: ishaa24)
                
//                print("asr 12:", date22)
                
                UserDefaults.standard.setValue(fajr12, forKey: "fajr")
                UserDefaults.standard.setValue(dhuhr12, forKey: "dhuhr")
                UserDefaults.standard.setValue(asr12, forKey: "asr")
                UserDefaults.standard.setValue(maghrib12, forKey: "maghrib")
                UserDefaults.standard.setValue(ishaa12, forKey: "ishaA")
                
//                self.containerView.prayersTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

//extension MuslimViewController: DismissProtocol {
//
//}
//extension MuslimViewController: CLLocationManagerDelegate {
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            self.locationManager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations[0]
//
////        self.selectedCoordinate = location
////        self.myLocation = location
////        self.display_map(location: location)
////        latestLocation = location
//        get_locationAddress(location: location.coordinate)
//
//    }
//}
