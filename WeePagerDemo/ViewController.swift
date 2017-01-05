//
//  ViewController.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyPagerDelegate {

    @IBOutlet weak var weePager_: WeePager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var vcArr = [UIViewController]()
        var vcTitle = "a"
        for i in 0...20 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "prova") as! ProvaViewController
            vc.title = "pagina" + String(i)
            vcArr.append(vc)
            vcTitle += "a"
        }
        //let imgArr = [UIImage].init(repeating: UIImage(named: "icon")!, count: vcArr.count)
        weePager_.set(viewControllers: vcArr, titles: nil, images: nil)
        weePager_.delegate = self
        self.view.addSubview(weePager_)
        
    }

    func pagerDidMoveToPage(index: Int) {
        print("moved: ", index)
    }
    
    func pagerIsMovingToPage(index: Int) {
        print("isMoving: ", index)
    }
}
