//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import SwiftUI


/// this class will be used to save images to the device
/// this will be a singleton instance
class LocalFileManager {
  
  static public let shared = LocalFileManager()
  private init() { }
  
  
  func saveImage(image: UIImage, imageName: String, folderName: String) {
    
    createFolderIfNeeded(folderName: folderName)
    
    // get the data and path from the image
    guard
      let data = image.pngData(),
      let url = getURLForImage(imageName: imageName, folderName: folderName)
    else { return }
    
    // save image to path
    do {
      try data.write(to: url)
    } catch {
      print("Error saving image\nImageName: \(imageName)\nErrorMessage: \(error.localizedDescription)")
    }
  }
  
  
  /// Returns the image if it exists in the folder with a given file name
  func getImage(imageName: String, folderName: String) -> UIImage? {
    
    guard let url = getURLForImage(imageName: imageName, folderName: folderName),
          FileManager.default.fileExists(atPath: url.path) else {
            return nil
          }
    
    return UIImage(contentsOfFile: url.path)
  }
  
  
  /// folder with a folderName needs to be created before trying to save into it
  private func createFolderIfNeeded(folderName: String) {
    
    guard let url = getURLForFolder(folderName: folderName) else { return }
    
    if FileManager.default.fileExists(atPath: url.path) {
      return
    }
    
    do {
      // create the directory
      try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      
    } catch {
      print("Error creating directory.\nFolderName: \(folderName)\nErrorMessage: \(error.localizedDescription)")
    }
  }
  
  
  private func getURLForFolder(folderName: String) -> URL? {
    
    // .cachesDirectory is least important
    // if we lose this file it's okay, we can fetch the data again
    guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }
    
    return url.appendingPathComponent(folderName)
  }
  
  
  /// ```
  /// URL will be like - //application/folderName/imageName.png
  /// ```
  private func getURLForImage(imageName: String, folderName: String) -> URL? {
    
    guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
    
    return folderURL.appendingPathComponent(imageName + ".png")
  }
}
