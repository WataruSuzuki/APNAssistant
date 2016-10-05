//
//  AvailableUpdateHelper.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/12.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct DownloadProfiles {
    static let serverUrl = "https://watarusuzuki.github.io/"
    
    static let apnProfiles = "apn-profiles"
    static let jsonsDir = apnProfiles + "/jsons/"
    static let resourcesDir = apnProfiles + "/resources/"
    
    static let profileItems = "items"
    static let profileName = "name"
    static let profileUrl = "profile_url"
    static let version = "version"
    static let ERROR_INDEX = (-1)
    
    enum json: Int {
        case globalSIM = 0,
        albania,
        algeria,
        angola,
        anguilla,
        antigua_and_Barbuda,
        argentina,
        armenia,
        australia,
        austria,
        azerbaijan,
        bahamas,
        bahrain,
        barbados,
        belarus,
        belgium,
        belize,
        benin,
        bermuda,
        bhutan,
        bolivia,
        botswana,
        brazil,
        british_Virgin_Islands,
        brunei,
        bulgaria,
        burkina_Faso,
        cambodia,
        canada,
        cape_Verde,
        cayman_Islands,
        chad,
        chile,
        china,
        colombia,
        congo_Republic_of,
        costa_Rica,
        croatia,
        cyprus,
        czech_Republic,
        denmark,
        dominica,
        dominican_Republic,
        ecuador,
        egypt,
        el_Salvador,
        estonia,
        fiji,
        finland,
        france,
        gambia,
        germany,
        ghana,
        greece,
        grenada,
        guatemala,
        guinea_Bissau,
        guyana,
        honduras,
        hong_Kong,
        hungary,
        iceland,
        india,
        indonesia,
        ireland,
        israel,
        italy,
        jamaica,
        japan,
        jordan,
        kazakhstan,
        kenya,
        kuwait,
        kyrgyzstan,
        laos,
        latvia,
        lebanon,
        liberia,
        lithuania,
        luxembourg,
        macao,
        macedonia,
        madagascar,
        malawi,
        malaysia,
        mali,
        malta,
        mauritania,
        mauritius,
        mexico,
        micronesia,
        moldova,
        mongolia,
        montserrat,
        mozambique,
        namibia,
        nepal,
        netherlands,
        new_Zealand,
        nicaragua,
        niger,
        nigeria,
        norway,
        oman,
        pakistan,
        palau,
        panama,
        papua_New_Guinea,
        paraguay,
        peru,
        philippines,
        poland,
        portugal,
        qatar,
        republic_of_Korea,
        romania,
        russia,
        saudi_Arabia,
        senegal,
        seychelles,
        sierra_Leone,
        singapore,
        slovakia,
        slovenia,
        solomon_Islands,
        south_Africa,
        spain,
        sri_Lanka,
        st_Kitts,
        st_Lucia,
        st_Vincent_and_the_Grenadines,
        suriname,
        swaziland,
        sweden,
        switzerland,
        taiwan,
        tajikistan,
        tanzania,
        thailand,
        trinidad_and_Tobago,
        tunisia,
        turkey,
        turkmenistan,
        turks_and_Caicos,
        uganda,
        uk,
        ukraine,
        united_Arab_Emirates,
        uruguay,
        usa,
        uzbekistan,
        venezuela,
        vietnam,
        yemen,
        zimbabwe,
        max
        
        init(fileName: String) {
            switch fileName {
            case json.globalSIM.getFileName():  self = json.globalSIM
            case json.albania.getFileName():	self = json.albania
            case json.algeria.getFileName():	self = json.algeria
            case json.angola.getFileName():     self = json.angola
            case json.anguilla.getFileName():	self = json.anguilla
            case json.antigua_and_Barbuda.getFileName():	self = json.antigua_and_Barbuda
            case json.argentina.getFileName():	self = json.argentina
            case json.armenia.getFileName():	self = json.armenia
            case json.australia.getFileName():	self = json.australia
            case json.austria.getFileName():	self = json.austria
            case json.azerbaijan.getFileName():	self = json.azerbaijan
            case json.bahamas.getFileName():	self = json.bahamas
            case json.bahrain.getFileName():	self = json.bahrain
            case json.barbados.getFileName():	self = json.barbados
            case json.belarus.getFileName():	self = json.belarus
            case json.belgium.getFileName():	self = json.belgium
            case json.belize.getFileName():     self = json.belize
            case json.benin.getFileName():      self = json.benin
            case json.bermuda.getFileName():	self = json.bermuda
            case json.bhutan.getFileName():     self = json.bhutan
            case json.bolivia.getFileName():	self = json.bolivia
            case json.botswana.getFileName():	self = json.botswana
            case json.brazil.getFileName():     self = json.brazil
            case json.british_Virgin_Islands.getFileName():	self = json.british_Virgin_Islands
            case json.brunei.getFileName():     self = json.brunei
            case json.bulgaria.getFileName():	self = json.bulgaria
            case json.burkina_Faso.getFileName():	self = json.burkina_Faso
            case json.cambodia.getFileName():	self = json.cambodia
            case json.canada.getFileName():     self = json.canada
            case json.cape_Verde.getFileName():	self = json.cape_Verde
            case json.cayman_Islands.getFileName():	self = json.cayman_Islands
            case json.chad.getFileName():       self = json.chad
            case json.chile.getFileName():      self = json.chile
            case json.china.getFileName():      self = json.china
            case json.colombia.getFileName():	self = json.colombia
            case json.congo_Republic_of.getFileName():	self = json.congo_Republic_of
            case json.costa_Rica.getFileName():	self = json.costa_Rica
            case json.croatia.getFileName():	self = json.croatia
            case json.cyprus.getFileName():     self = json.cyprus
            case json.czech_Republic.getFileName():	self = json.czech_Republic
            case json.denmark.getFileName():	self = json.denmark
            case json.dominica.getFileName():	self = json.dominica
            case json.dominican_Republic.getFileName():	self = json.dominican_Republic
            case json.ecuador.getFileName():	self = json.ecuador
            case json.egypt.getFileName():      self = json.egypt
            case json.el_Salvador.getFileName():self = json.el_Salvador
            case json.estonia.getFileName():	self = json.estonia
            case json.fiji.getFileName():       self = json.fiji
            case json.finland.getFileName():	self = json.finland
            case json.france.getFileName():     self = json.france
            case json.gambia.getFileName():     self = json.gambia
            case json.germany.getFileName():	self = json.germany
            case json.ghana.getFileName():      self = json.ghana
            case json.greece.getFileName():     self = json.greece
            case json.grenada.getFileName():	self = json.grenada
            case json.guatemala.getFileName():	self = json.guatemala
            case json.guinea_Bissau.getFileName():	self = json.guinea_Bissau
            case json.guyana.getFileName():     self = json.guyana
            case json.honduras.getFileName():	self = json.honduras
            case json.hong_Kong.getFileName():	self = json.hong_Kong
            case json.hungary.getFileName():	self = json.hungary
            case json.iceland.getFileName():	self = json.iceland
            case json.india.getFileName():      self = json.india
            case json.indonesia.getFileName():	self = json.indonesia
            case json.ireland.getFileName():	self = json.ireland
            case json.israel.getFileName():     self = json.israel
            case json.italy.getFileName():      self = json.italy
            case json.jamaica.getFileName():	self = json.jamaica
            case json.japan.getFileName():      self = json.japan
            case json.jordan.getFileName():     self = json.jordan
            case json.kazakhstan.getFileName():	self = json.kazakhstan
            case json.kenya.getFileName():      self = json.kenya
            case json.kuwait.getFileName():     self = json.kuwait
            case json.kyrgyzstan.getFileName():	self = json.kyrgyzstan
            case json.laos.getFileName():       self = json.laos
            case json.latvia.getFileName():     self = json.latvia
            case json.lebanon.getFileName():	self = json.lebanon
            case json.liberia.getFileName():	self = json.liberia
            case json.lithuania.getFileName():	self = json.lithuania
            case json.luxembourg.getFileName():	self = json.luxembourg
            case json.macao.getFileName():      self = json.macao
            case json.macedonia.getFileName():	self = json.macedonia
            case json.madagascar.getFileName():	self = json.madagascar
            case json.malawi.getFileName():     self = json.malawi
            case json.malaysia.getFileName():	self = json.malaysia
            case json.mali.getFileName():       self = json.mali
            case json.malta.getFileName():      self = json.malta
            case json.mauritania.getFileName():	self = json.mauritania
            case json.mauritius.getFileName():	self = json.mauritius
            case json.mexico.getFileName():     self = json.mexico
            case json.micronesia.getFileName():	self = json.micronesia
            case json.moldova.getFileName():	self = json.moldova
            case json.mongolia.getFileName():	self = json.mongolia
            case json.montserrat.getFileName():	self = json.montserrat
            case json.mozambique.getFileName():	self = json.mozambique
            case json.namibia.getFileName():	self = json.namibia
            case json.nepal.getFileName():      self = json.nepal
            case json.netherlands.getFileName():self = json.netherlands
            case json.new_Zealand.getFileName():self = json.new_Zealand
            case json.nicaragua.getFileName():	self = json.nicaragua
            case json.niger.getFileName():      self = json.niger
            case json.nigeria.getFileName():	self = json.nigeria
            case json.norway.getFileName():     self = json.norway
            case json.oman.getFileName():       self = json.oman
            case json.pakistan.getFileName():	self = json.pakistan
            case json.palau.getFileName():      self = json.palau
            case json.panama.getFileName():     self = json.panama
            case json.papua_New_Guinea.getFileName():	self = json.papua_New_Guinea
            case json.paraguay.getFileName():	self = json.paraguay
            case json.peru.getFileName():       self = json.peru
            case json.philippines.getFileName():self = json.philippines
            case json.poland.getFileName():     self = json.poland
            case json.portugal.getFileName():	self = json.portugal
            case json.qatar.getFileName():      self = json.qatar
            case json.republic_of_Korea.getFileName():	self = json.republic_of_Korea
            case json.romania.getFileName():	self = json.romania
            case json.russia.getFileName():     self = json.russia
            case json.saudi_Arabia.getFileName():	self = json.saudi_Arabia
            case json.senegal.getFileName():	self = json.senegal
            case json.seychelles.getFileName():	self = json.seychelles
            case json.sierra_Leone.getFileName():	self = json.sierra_Leone
            case json.singapore.getFileName():	self = json.singapore
            case json.slovakia.getFileName():	self = json.slovakia
            case json.slovenia.getFileName():	self = json.slovenia
            case json.solomon_Islands.getFileName():	self = json.solomon_Islands
            case json.south_Africa.getFileName():   self = json.south_Africa
            case json.spain.getFileName():      self = json.spain
            case json.sri_Lanka.getFileName():	self = json.sri_Lanka
            case json.st_Kitts.getFileName():	self = json.st_Kitts
            case json.st_Lucia.getFileName():	self = json.st_Lucia
            case json.st_Vincent_and_the_Grenadines.getFileName():	self = json.st_Vincent_and_the_Grenadines
            case json.suriname.getFileName():	self = json.suriname
            case json.swaziland.getFileName():	self = json.swaziland
            case json.sweden.getFileName():     self = json.sweden
            case json.switzerland.getFileName():self = json.switzerland
            case json.taiwan.getFileName():     self = json.taiwan
            case json.tajikistan.getFileName():	self = json.tajikistan
            case json.tanzania.getFileName():	self = json.tanzania
            case json.thailand.getFileName():	self = json.thailand
            case json.trinidad_and_Tobago.getFileName():	self = json.trinidad_and_Tobago
            case json.tunisia.getFileName():	self = json.tunisia
            case json.turkey.getFileName():     self = json.turkey
            case json.turkmenistan.getFileName():	self = json.turkmenistan
            case json.turks_and_Caicos.getFileName():	self = json.turks_and_Caicos
            case json.uganda.getFileName():     self = json.uganda
            case json.uk.getFileName():         self = json.uk
            case json.ukraine.getFileName():	self = json.ukraine
            case json.united_Arab_Emirates.getFileName():	self = json.united_Arab_Emirates
            case json.uruguay.getFileName():	self = json.uruguay
            case json.usa.getFileName():        self = json.usa
            case json.uzbekistan.getFileName():	self = json.uzbekistan
            case json.venezuela.getFileName():	self = json.venezuela
            case json.vietnam.getFileName():	self = json.vietnam
            case json.yemen.getFileName():      self = json.yemen
            case json.zimbabwe.getFileName():	self = json.zimbabwe
            default:
                self = json.max
            }
        }
        
        func getFileName() -> String {
            return String(describing: self) + ".json"
        }
        
        func toString() -> String {
            return String(describing: self)
        }
    }
}

class AvailableUpdateHelper: NSObject {
    
    var publicProfileList = [NSArray](repeating: [], count: DownloadProfiles.json.max.rawValue)
    var updateIndexSection = 0
    var updateUrl = [URL]()
    var senderDelegate: URLSessionDownloadDelegate!
    
    func loadCachedJsonList() {
        let filemanager = FileManager()
        let files = filemanager.enumerator(atPath: UtilCocoaHTTPServer().getTargetFilePath("", fileType: ""))
        while let file = files?.nextObject() as? String {
            if isJsonFile(file) {
                let country = file.replacingOccurrences(of: ".json", with: "")
                let path = UtilCocoaHTTPServer().getTargetFilePath(country, fileType: ".json")
                let localUrl = URL(fileURLWithPath: path)
                if let jsonData = try? Data(contentsOf: localUrl) {
                    let items = serializeCountryJsonData(jsonData)
                    addProfileList(localUrl, items: items)
                }
            }
        }
    }
    
    func isJsonFile(_ file: String) -> Bool {
        if file.contains(DownloadProfiles.version)
        || !file.contains(".json"){
            return false
        }
        return true
    }
    
    func getCountryFileUrl(_ response: URLResponse) -> URL? {
        if let url = response.url {
            return url
        }
        return nil
    }
    
    func getOriginalFileName(_ fileName: String) -> String {
        if fileName.contains(DownloadProfiles.apnProfiles) {
            let replaced = fileName.replacingOccurrences(of: DownloadProfiles.apnProfiles, with: "")
            return replaced.replacingOccurrences(of: "-", with: "")
        }
        return fileName
    }
    
    func getUpdateIndexSection(_ url: URL) -> Int {
        let country = DownloadProfiles.json.init(fileName: getOriginalFileName(url.lastPathComponent))
        return country.rawValue
    }
    
    func generateFileNameFromLastPathComponent(_ responseUrl: URL, lastPathComponent: String, isCheckVersion: Bool) -> String {
        if isCheckVersion {
            return getVersionCheckFileName(lastPathComponent)
        } else {
            return getCountryFileName(responseUrl, lastPathComponent: lastPathComponent)
        }
    }
    
    func getVersionCheckFileName(_ lastPathComponent: String) -> String {
        return lastPathComponent.replacingOccurrences(of: ".json", with: "")
    }
    
    func getCountryFileName(_ responseUrl: URL, lastPathComponent: String) -> String {
        let fileName = lastPathComponent.replacingOccurrences(of: ".json", with: "-" + DownloadProfiles.apnProfiles)
        return fileName
    }
    
    func moveJSONFilesFromURLSession(_ downloadTask: URLSessionDownloadTask, location: URL) {
        guard let response = downloadTask.response else { return }
        moveJSONFilesFromURLResponse(response, location: location, isCheckVersion: false)
    }
    
    func moveJSONFilesFromURLResponse(_ response: URLResponse, location: URL, isCheckVersion: Bool) {
        guard let responseUrl = response.url else { return }
        let lastPathComponent = responseUrl.lastPathComponent
        
        let fileName = generateFileNameFromLastPathComponent(responseUrl, lastPathComponent: lastPathComponent, isCheckVersion: isCheckVersion)
        let filePath = UtilCocoaHTTPServer().getTargetFilePath(fileName, fileType: ".json")
        moveDownloadItemAtURL(filePath, location: location)
        
        let localUrl = URL(fileURLWithPath: filePath)
        if let jsonData = try? Data(contentsOf: localUrl) {
            if isCheckVersion {
                parseVersionCheckJson(jsonData)
            } else {
                parseCountryJson(response, jsonData: jsonData)
            }
        }
    }
    
    func moveDownloadItemAtURL(_ filePath: String, location: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            try! fileManager.removeItem(atPath: filePath)
        }
        
        let localUrl = URL(fileURLWithPath: filePath)
        do {
            try fileManager.moveItem(at: location, to: localUrl)
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
    }
    
    func parseVersionCheckJson(_ jsonData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
            
            let items = json.object(forKey: DownloadProfiles.profileItems) as! NSArray
            let actualVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            print("actualVersion = \(actualVersion)")
            let myAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
            print("myAppName = \(myAppName)")
            
            for i in 0  ..< items.count  {
                let item = items[i] as! NSDictionary
                if myAppName == item.object(forKey: DownloadProfiles.profileName) as! String {
                    let requiredVersion = item.object(forKey: DownloadProfiles.version) as! String
                    print("requiredVersion = \(requiredVersion)")
                    let compareResult = requiredVersion.compare(actualVersion, options: .numeric)
                    print("compareResult = \(compareResult.rawValue)")
                    if compareResult == .orderedAscending {
                        //do nothing
                    } else {
                        let ud = UtilUserDefaults()
                        ud.isAvailableStore = true
                        ud.memoryVersion = actualVersion
                        break
                    }
                }
            }
            
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
    }
    
    func parseCountryJson(_ response: URLResponse, jsonData: Data) {
        let items = serializeCountryJsonData(jsonData)
        
        if let countryUrl = getCountryFileUrl(response) {
            addProfileList(countryUrl, items: items)
        }
    }
    
    func addProfileList(_ countryUrl: URL, items: NSArray) {
        let section = getUpdateIndexSection(countryUrl)
        if section != DownloadProfiles.ERROR_INDEX && section < publicProfileList.count {
            publicProfileList[section] = items
        }
    }
    
    func serializeCountryJsonData(_ jsonData: Data) -> NSArray {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
            
            let items = json.object(forKey: DownloadProfiles.profileItems) as! NSArray
            //for i in 0  ..< items.count  {
                //print(items[i].object(forKey: DownloadProfiles.profileName) as! NSString)
            //}
            let sortDescriptor = NSSortDescriptor(key: DownloadProfiles.profileName, ascending: true)
            return items.sortedArray(using: [sortDescriptor]) as NSArray
            
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
        return NSArray()
    }
    
    func startJsonFileDownload(_ delegate: URLSessionDownloadDelegate) {
        updateIndexSection = 0
        senderDelegate = delegate
        updateUrl = [URL]()
        for index in 0..<DownloadProfiles.json.max.rawValue {
            let url = URL(string: DownloadProfiles.serverUrl + DownloadProfiles.jsonsDir + DownloadProfiles.json(rawValue: index)!.getFileName())
            updateUrl.append(url!)
        }
        executeNextDownloadTask()
    }
    
    func executeNextDownloadTask() {
        print(#function)
        print("updateIndexSection = \(updateIndexSection)")
        if updateIndexSection <= updateUrl.count {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: senderDelegate, delegateQueue: OperationQueue.main)
            session.downloadTask(with: updateUrl[updateIndexSection]).resume()
            updateIndexSection += 1
        }
    }
    
    func stopDownloadTask() {
        updateIndexSection = updateUrl.count + 1
    }
}
