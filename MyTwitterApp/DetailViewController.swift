//
//  DetailViewController.swift
//  MyTwitterApp
//
//  Created by kazucocoa on 27/01/2016.
//  Copyright © 2016 kazucocoa. All rights reserved.
//

import UIKit
import pop
import Alamofire

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    private var myButton: UIButton!

    private var myView: UIView!

    private var isTapped: Bool = false
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        myView = UIView(frame: CGRectMake(0, 0, 10, 10))
        myView.backgroundColor = UIColor.orangeColor()
        myView.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(myView)

        myButton = UIButton()
        myButton.setTitle("touch here :)", forState: .Normal)
        myButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myButton.setTitle("Tapped!", forState: .Highlighted)
        myButton.setTitleColor(UIColor.redColor(), forState: .Highlighted)
        myButton.frame = CGRectMake(0, 0, 300, 50)
        myButton.layer.cornerRadius = 10
        myButton.layer.borderWidth = 1
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:200)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchDown)
        self.view.addSubview(myButton)
    }
    
    internal func onClickMyButton(sender: UIButton) {
        switch isTapped {
        case true:
            self.isTapped = false
            self.scaleDownView(myView)

            Alamofire.request(.GET, "https://api.github.com/users/KazuCocoa")
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization

                    if let JSON = response.result.value {
                        self.detailDescriptionLabel.text = JSON as? String
                    }
            }

        case false:
            self.isTapped = true
            self.scaleUpView(myView)
        }
    }

    internal func scaleUpView(view: UIView) {
        let anime = POPSpringAnimation()

        anime.property = POPAnimatableProperty.propertyWithName(kPOPLayerSize) as! POPAnimatableProperty
        anime.springBounciness = 10.0
        anime.springSpeed = 5.0
        
        anime.toValue = NSValue(CGSize:CGSizeMake(300, 300))
        view.pop_addAnimation(anime, forKey: "bound")
    }
 
    internal func scaleDownView(view: UIView) {
        let anime = POPSpringAnimation()

        anime.property = POPAnimatableProperty.propertyWithName(kPOPLayerSize) as! POPAnimatableProperty
        anime.springBounciness = 10.0
        anime.springSpeed = 5.0
        
        anime.toValue = NSValue(CGSize:CGSizeMake(10, 10))
        view.pop_addAnimation(anime, forKey: "bound")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

