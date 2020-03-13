//
//  API.swift
//  Random Users
//
//  Created by Kerby Jean on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class API {
    
    // MARK: - Private
    
    var users = [User]()
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetch(_ completion: @escaping (User?, Error?) -> Void) {
        let request = URLRequest(url: baseURL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("Bad data")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObject = try jsonDecoder.decode(User.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
   }
    
    func fetchImage(_ urlString: String, _ completion: @escaping (Data?, Error?) -> Void) {
        if let imageUrl = URL(string: urlString) {
           let request = URLRequest(url: imageUrl)
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   NSLog("Error: \(error)")
               } else {
                   guard let data = data else { return }
                   completion(data, nil)
               }
           }.resume()
        }
    }
}
