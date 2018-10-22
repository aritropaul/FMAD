//
//  HomeViewController.swift
//  FMAD
//
//  Created by Aritro Paul on 11/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var username = ""

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    @IBAction func listTapped(_ sender: Any) {
    }
    
    @IBAction func bookTapped(_ sender: Any) {
        performSegue(withIdentifier: "book", sender: Any?.self)
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        getLocationfromIP { (city) in
            if(city == "Internet Problem") {
                let alert = UIAlertController(title: city, message: city, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
                
                self.present(alert, animated:true)
            }
            else {
                DispatchQueue.main.async {
                    self.locationLabel.text = city.uppercased()
                }
            }
        }
    }
   
    override func viewDidLayoutSubviews() {
        bookButton.makeCard(myView: bookButton)
        listButton.makeCard(myView: listButton)
        welcomeLabel.text = "Welcome, \(username)"
        bookButton.backgroundColor = .white
        listButton.backgroundColor = .white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func getLocationfromIP(completion :@escaping(String) -> ()){
        let url = URL(string: "http://ip-api.com/json")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do{
                let decoder = JSONDecoder()
                let location = try decoder.decode(Location.self, from: data)
                completion(location.city)
            }
            catch{
                completion("Internet Problem")
            }
        }.resume()
    }
}

extension UIView {
    func makeCard(myView: UIView){
        myView.layer.cornerRadius = 20.0
        myView.layer.shadowColor = grayColor.cgColor
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        myView.layer.shadowRadius = 20.0
        myView.layer.shadowOpacity = 0.4
    }
}
