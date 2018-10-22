//
//  Services.swift
//  FMAD
//
//  Created by Pranav Karnani on 18/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import Foundation
var locationList = Locations(data: [])
class Services {
    static let shared: Services = Services()
    
    func getLocations(completion:@escaping(Int) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://api.myjson.com/bins/hj8hg")!) { (data, response, error) in
            if error != nil {
                completion(0)
            }
            else {
                guard let data = data else { return }
                do {
                    locationList = try JSONDecoder().decode(Locations.self, from: data)
                    completion(1)
                }
                    
                catch {
                    completion(0)
                    print("\(error.localizedDescription)")
                }
                
            }
            
        }.resume()
    }
}

