//
//  MY_IO.swift
//  Holoss
//
//  Created by Rok Kosuta on 07/02/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation


import Foundation

struct MY_IO
{
    
    static func save_string_to_standar_path(_ string : String)
    {
        var standard_path : String
        {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/Hologram_standard.txt")
        }
        
        // Set the file path
        let path =  standard_path
        
        // Set the contents
        let contents = string
        
        do {
            // Write contents to file
            try contents.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    static func write_to_file(txt : String, name : String)
    {
        let fileName = name
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        print("File Path:", fileURL.path)
        
        let writeString = txt
        do
        {
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError
        {
            print("Failed to write to url")
            print(error)
        }
        
    }
    
    static func list_of_files_in_directory_and_return_all_paths() -> [String]
    {
        var response : [String] = []
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            for i in fileURLs
            {
                response.append(i.path)
            }
        }
        catch
        {
            print("list_of_files_in_directory Error")
            // print("Error while enumerating files \(destinationFolder.path): \(error.localizedDescription)")
        }
        return response
    }
    
    static func list_of_files_in_directory_and_return_all_file_names() -> [String]
    {
        var response : [String] = []
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            for i in fileURLs
            {
                response.append(i.lastPathComponent.components(separatedBy: ".").first!)
            }
        }
        catch
        {
            print("list_of_files_in_directory Error")
            // print("Error while enumerating files \(destinationFolder.path): \(error.localizedDescription)")
        }
        return response
    }
    
    static func remove_file(name : String)
    {
        let fileName = name
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: url.path)
            {
                print("File exit we will try to remove it!")
                // Delete file
                try fileManager.removeItem(atPath: url.path)
            } else
            {
                print("File does not exist")
            }
            
        }
        catch let error as NSError
        {
            print("An error took place: \(error)")
        }
    }
    
    static func return_creation_date_of_file( name : String ) -> Date?
    {
        let fileName = name
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: url.path)
            {
                return try (fileManager.attributesOfItem(atPath: url.path)[FileAttributeKey.creationDate] as? Date)
            } else
            {
                print("File does not exist")
            }
            
        }
        catch let error as NSError
        {
            print("An error took place: \(error)")
        }
        return nil
    }
    
    static func read_file(name : String) -> String
    {
        let fileName = name
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var readString = ""
        do
        {
            readString = try String(contentsOf : fileURL)
        } catch let error as NSError
        {
            print("Failed to read file")
            print(error)
        }
        //print("Contents of the file : "+readString)
        return readString
    }
    
    static func remove_all_files_in_inbox_directory() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("Inbox")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
    static func get_file_string_in_bundle_with(name : String, ext : String) -> String?
    {
        guard let path = Bundle.main.path(forResource: name, ofType: ext) else
        {
            return nil
        }
        return try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
}

