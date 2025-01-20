//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init(){ }
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let url = getURlForImages(imageName: imageName, folderName: folderName) else {
                return
            }
        do{
            try data.write(to: url)
            print("Image saved successfuly")
        }catch{
            print("Error saving the image \(imageName) \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName: String, folderName: String)->UIImage?{
        guard
            let url = getURlForImages(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        if #available(iOS 16.0, *) {
            return UIImage(contentsOfFile: url.path())
        } else {
            return UIImage(contentsOfFile: url.path)
        }
        
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let folderUrl = getUrlForFolder(folderName: folderName) else{
            return
        }
        
        if !FileManager.default.fileExists(atPath: folderUrl.path){
            do{
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true)
                print("Folder Created successfuly")
            }catch{
                print("Error creating the folder \(folderName) \(error.localizedDescription)")
            }
        }
        
    }
    
    private func getUrlForFolder(folderName: String)->URL?{
        guard
            let url = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first else{
            return nil
        }
        
        return url.appendingPathComponent(folderName)
        
    }
    
    private func getURlForImages(imageName: String,folderName: String)->URL? {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else { return nil }
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
    
}
