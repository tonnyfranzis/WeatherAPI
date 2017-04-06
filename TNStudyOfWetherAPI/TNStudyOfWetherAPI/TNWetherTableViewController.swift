//
//  TNWetherTableViewController.swift
//  TNStudyOfWetherAPI
//
//  Created by Prasobh Veluthakkal on 06/02/17.
//  Copyright © 2017 Focaloid. All rights reserved.
//

import UIKit

class TNWetherTableViewController: UITableViewController,UISearchBarDelegate {
    
 
    @IBOutlet weak var temperature: UITextField!
    
   
    @IBOutlet weak var imageWeather: UIImageView!
    
    @IBOutlet weak var searchBarButton: UISearchBar!
    
    @IBOutlet weak var descriptionText: UITextField!
    
    
    @IBOutlet weak var dtText: UITextField!
    
    
    @IBOutlet weak var codText: UITextField!
    
    var weatherDictionary = [String:String]()
    var weatherSearch : String?
    var temperautreValue : Double?
    enum weatherSetting : String
    
    {
        case baseUrl = "http://api.openweathermap.org/data/2.5/weather"
        case api = "4e63f48bb2d090d7fb7d80f6447ace6a"
        case image = "http://openweathermap.org/img/w/"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      searchBarButton.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func swichButton(sender: AnyObject)
    {
       
        if sender.on == true
        {
           temperature.text = String(temperautreValue!)
        }
        if sender.on == false
        {
            temperature.text = String (convertToCelsius(temperautreValue!))
            
        }
                    }
    func convertToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    func getApi()
{
    let weatherUrlString = weatherSetting.baseUrl.rawValue + "?q=\(weatherSearch!)&appid=" + weatherSetting.api.rawValue
    print(weatherUrlString)
    let weatherUrl = NSURL(string: weatherUrlString)
    let requestUrl : NSURLRequest = NSURLRequest(URL: weatherUrl!)
    let taskF = NSURLSession.sharedSession().dataTaskWithRequest(requestUrl){ (data, response, error) in
        
        do
        {
            let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
         
            dispatch_async(dispatch_get_main_queue(),{
            
                if let wetherArray = responseDictionary["weather"]! as? [[String:AnyObject]]
            {
                
                self.descriptionText.text = wetherArray[0]["description"] as? String
                let url:NSURL = NSURL(string: weatherSetting.image.rawValue + "\(wetherArray[0]["icon"]!)" + ".png")!
                print(url)
                let data:NSData = NSData(contentsOfURL: url)!
                

                self.imageWeather.image = UIImage(data: data)
                }
        
                if let dt = responseDictionary["dt"] as? Double
                {
                    self.dtText.text = String(dt)
                
                }
                if let cod = responseDictionary["cod"] as? Int
                {
                    self.codText.text = String(cod)
                }
                if let temp = responseDictionary["main"] as? [String:AnyObject]
                {
                    print(temp)
                    self.temperautreValue = temp["temp"] as? Double
                    self.temperature.text = String(temp["temp"]!)
                                    }
                
                
            })
}
}
    taskF.resume()
}
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        weatherSearch = searchBarButton.text
        if (weatherSearch == nil)
        {
        searchBarButton.text = "enter a value"
        }
        else
        {
            getApi()
        }
    }
}



              