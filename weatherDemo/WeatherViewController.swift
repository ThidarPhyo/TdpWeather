//
//  WeatherViewController.swift
//  weatherDemo
//
//  Created by Thidar Phyo on 9/6/19.
//  Copyright © 2019 Thidar Phyo. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView
import Kingfisher


class WeatherDataModel {
    
    var desc: String
    var icon: String?
    var city: String
    var temp: Int = 0
    var wind: String?
    var time: Int?
    var mainType: [String: Any]?

    
    init(desc: String, city: String) {
        
        self.desc = desc
        self.city = city
    }

}

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var busyView: NVActivityIndicatorView?
    let locationManager = CLLocationManager()
    
    var lists = [[String:Any]]()
    var citys = [String: Any]()
    //https://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&appid=3340c381811c078125d86cccfd0b36fa
    var weatherDataModel : WeatherDataModel?
    
    var currentWeather: WeatherDataModel?
    let forecastApi = "https://api.openweathermap.org/data/2.5/forecast/daily?id=1327865&appid=fe7bdbcd157904b5f4d1b6e194b2cfa4"
    
    @IBOutlet weak var currentCity: UILabel!
    
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var currentDate: UILabel!
    
    @IBOutlet weak var currentYgn: UIImageView!
    
    @IBOutlet weak var busyInt: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataAla()
        
        setup()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    func setup() {
        let busyFrame = CGRect(x: 30, y: 30, width: 100, height: 100)
        busyView = NVActivityIndicatorView(frame: busyFrame)
        busyView?.color = UIColor.red
        busyView?.type = .ballScaleRippleMultiple
        busyView?.center = view.center
        print(busyView)
    }
    func showBusy() {
        view.addSubview(busyView!)
        
        busyView?.startAnimating()
    }
    func hideBusy() {
        
        busyView?.stopAnimating()
        busyView?.removeFromSuperview()
    }
    func currentData() {
        
        
        //imageView.kf.indicatorType = .activity
        //imageView.kf.setImage(with: url)
        var dt = 0.0, icon = "" ,temp = 0.0
        dt = self.lists[0]["dt"] as? Double ?? 0.0
        let milisecond = dt
        let dateVar = Date.init(timeIntervalSince1970: milisecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        currentDate.text = dateFormatter.string(from: dateVar)
        let weather = self.lists[0]["weather"] as?[ [String:Any]]
        icon = weather![0]["icon"] as! String ?? ""
        let main = self.lists[0]["temp"] as? [String:Any]
        temp = main!["day"] as? Double ?? 0.0
        currentYgn.image = UIImage(named: icon ?? "")
        //currentYgn.kf.setImage(with: currentYgn.image)
        let tempInt = Int((temp - 273.15).rounded())
        currentTemp.text = "\(tempInt) ℃"
        currentCity.text = citys["name"] as? String ?? ""
        self.tableView.reloadData()
    }

    func fetchDataAla() {
        print(forecastApi)
        Alamofire.request(forecastApi).responseJSON { (response) in
            print("Hey! I got data")
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]// *******
                {
                    
                    if let list = dictionary["list"] as? [[String:Any]]{
                        
                        self.lists = list
                        let city = dictionary["city"] as? [String:Any]
                        self.citys = city!
                        OperationQueue.main.addOperation {
                            self.currentData()
                        }

                        self.tableView.reloadData()
                        
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }//******
            OperationQueue.main.addOperation {
                self.hideBusy()
            }

        }
//        busyInt.startAnimating()
//        busyInt.isHidden = false
        OperationQueue.main.addOperation {
            self.showBusy()
        }
    }
//    func hideBusy(){
//        busyInt.isHidden = true
//        busyInt.stopAnimating()
//    }
//    func showBusy() {
//        busyInt.isHidden = false
//        busyInt.startAnimating()
//    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        var dt = 0.0
        var icon = "", temp = 0.0
        if(self.lists.count > indexPath.row){
            
            dt = self.lists[indexPath.row]["dt"] as? Double ?? 0.0
            let weather = self.lists[indexPath.row]["weather"] as?[ [String:Any]]
            icon = weather![0]["icon"] as! String ?? ""
            let main = self.lists[indexPath.row]["temp"] as? [String:Any]
            temp = main!["day"] as? Double ?? 0.0
            
        }
        
        
        let tempInt = Int((temp - 273.15).rounded())
        cell.tempLabel.text = "\(tempInt) ℃"
        //cell.dailyLabel.text = currentCity
        let milisecond = dt
        let dateVar = Date.init(timeIntervalSince1970: milisecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" //dd-MM-yyyy hh:mm
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        cell.dailyLabel.text = dateFormatter.string(from: dateVar)
        cell.dayLabel.text = dateFormatterGet.string(from: dateVar)
        
        cell.imgView.image = UIImage(named: icon ?? "")
        self.tableView.reloadRows(at: [indexPath], with: .none)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity , -500, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    

}

