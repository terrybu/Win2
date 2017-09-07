//
//  AboutPIViewControlller.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MapKit
import Contacts

private let kLeftSidePadding: CGFloat = 15

class AboutPIViewController: ParentViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    
    var navDrawerVC : LeftNavDrawerController?
    @IBOutlet var segmentedControl : HMSegmentedControl!
    @IBOutlet var horizontalScrollView : UIScrollView!

    convenience init() {
        self.init(nibName: "AboutPIViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStandardUIForViewControllers()
        let viewWidth = self.view.frame.width
        setUpHMSegmentedControl(viewWidth)
        setUpHorizontalScrollView(viewWidth)
        setUpCanvasesInsideScrollView(viewWidth)
    }
    
    fileprivate func setUpCanvasesInsideScrollView(_ viewWidth: CGFloat) {
        let viewCanvas1 = setUpCanvas(0, headerTitle: "In2 소개", bodyText:
            "'Come IN2 Christ, Go IN2 the World'\n\n온누리 교회는 사도행전적 ‘바로 그 교회’의 꿈을 가지고 시작되었고 지난 20년동안 사도행전적인 교회를 꿈꾸며 ‘가서 모든 족속을 제자 삼으라’고 말씀하신 예수님의 명령에 순종하려고 노력해왔습니다. 교회에서 하나님을 만나(COME) 하나님의 일꾼으로 성장하여, 세상으로 나가(GO) 평신도들이 전문인 선교사로 세상에 선한 영향력을 끼쳐 세상을 변화시키는 사역을 지속적으로 펼쳐나갈 것입니다.\n\n앞으로도 IN2(뉴욕) 온누리 교회는 말씀과 기도로 교회를 강건하게 세워나가며 문화 사역을 통하여 뉴욕의 한인 유학생, 직장인, 교포 2세들, 더 나아가서는 다인종 및 전세계에 복음을 전하는 ACTS 29을 써나갈 것입니다."
        )
        let viewCanvas2 = setUpCanvas(viewWidth, headerTitle: "청년부 소개", bodyText: "2013년 8월 인투교회 3부 예배 안에 청년부와 대학부 공동체가 분리되었으며, 2014년 청년부 예배(3부)와 대학부 예배(4부)로 예배가 증설되었습니다.\n\n2015년 2월 청년부는 86 st.  Amsterdam ave.  에 위치한 West Park Presbyterian Church의 건물을 빌려 West IN2 캠퍼스로 분리 개척되어, 맨하탄을 비롯한 뉴욕 5 BORO의 청년들이 함께 모여 예배하고 그후에 Hotel Pennsylvania 로 옮기게 되었습니다.")
        let viewCanvas3 = setUpCanvas3(viewWidth * 2, headerTitle: "목사님 인사말", bodyText: "크고 화려할 수록 아픈 사람이 많은 곳? 병원 그리고 교회입니다. 뉴욕이 크고 화려해서 아픈 사람이 많기에 Win2가 존재합니다. 뉴욕을 지배하는 영은 허영입니다. 아는 척, 있는 척, 강한 척, 바쁜 척 살지만 실은 늘 두려움과 공허함과 목마름이 있습니다. 예수님께서 연약한 내 모습 그대로 사랑하시기에 Win2가 존재합니다. \n\n가족이 있지만 멀리 있고 보호자가 있지만 나를 보호하지 않았기에 가족과 사랑을 찾아 방황합니다. 그 어느 곳에도 예수님 같은 분이 없기에 Win2가 존재합니다. 환자가 군사가 되는 곳, 내가 정직해 질 수 있는 곳, 뉴욕이 홈타운이 되는 이유, 내가 살 자리가 아니라 죽을 자리를 찾는 이들을 위한 청년공동체. 바로 Win2 입니다.")
        let viewCanvas4 = setUpCanvas4(viewWidth * 3, headerTitle: "주일예배", bodyText: "Hotel Pennsylvania - 청년부 오후 3:15PM \n18층 Penn Top - 사랑홀 \n401 7th Ave. 18th Floor, New York, NY 10001")
        horizontalScrollView.addSubview(viewCanvas1)
        horizontalScrollView.addSubview(viewCanvas2)
        horizontalScrollView.addSubview(viewCanvas3)
        horizontalScrollView.addSubview(viewCanvas4)
    }
    
    fileprivate func setUpHMSegmentedControl(_ viewWidth: CGFloat) {
        let viewWidth = self.view.frame.width
        segmentedControl.sectionTitles = ["In2 ", "청년부", "인사말", "위치"]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectionIndicatorLocation = .down
        
        let segControlTitleFont = UIFont(name: "NanumBarunGothicBold", size: 16.0)
        if let segControlTitleFont =  segControlTitleFont {
            //regular font
            segmentedControl.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor(rgba: "#bbbcbc"),
                NSFontAttributeName : segControlTitleFont
            ]
            //selected font
            segmentedControl.selectedTitleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.In2DeepPurple(),
                NSFontAttributeName : segControlTitleFont
            ]
        }
        
        segmentedControl.selectionIndicatorColor = UIColor.In2DeepPurple()
        segmentedControl.indexChangeBlock = ({ (index : NSInteger) -> Void in
            self.horizontalScrollView.scrollRectToVisible(CGRect(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: 200), animated: true)
        })
        self.view.addSubview(segmentedControl)
    }
    
    
    //MARK: Canvas Creation for Scrollview
    fileprivate func commonSetUpCodeCanvas(_ x: CGFloat, headerTitle: String) -> UIView {
        let width = self.view.frame.width
        let height = view.frame.size.height - 60
        let incompleteViewCanvas = UIView(frame: CGRect(x: x, y: 30, width: width, height: height))
        let bigBoldHeaderLabel = UILabel(frame: CGRect(x: kLeftSidePadding, y: 0, width: self.view.frame.width-30, height: 25))
        bigBoldHeaderLabel.text = headerTitle
        bigBoldHeaderLabel.font = UIFont(name: "NanumBarunGothicBold", size: 25)
        incompleteViewCanvas.addSubview(bigBoldHeaderLabel)
        return incompleteViewCanvas
    }
    
    fileprivate func setUpCanvas(_ x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let incompleteView = commonSetUpCodeCanvas(x, headerTitle: headerTitle)
        let textDescribeLabel = UILabel(frame: CGRect(x: kLeftSidePadding, y: 45, width: self.view.frame.width-30, height: incompleteView.frame.size.height))
        textDescribeLabel.numberOfLines = 0
        textDescribeLabel.text = bodyText
        textDescribeLabel.font = UIFont(name: "NanumBarunGothic", size: 16.0)
        textDescribeLabel.sizeToFit()
        incompleteView.addSubview(textDescribeLabel)
        return incompleteView
    }
    
    fileprivate func setUpCanvas3(_ x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let incompleteView = commonSetUpCodeCanvas(x, headerTitle: headerTitle)
        let bodyTextView = UITextView(frame: CGRect(x: kLeftSidePadding, y: 45, width: self.view.frame.width-30, height: incompleteView.frame.height))
        bodyTextView.text = bodyText
        bodyTextView.font = UIFont(name: "NanumBarunGothic", size: 16.0)
        bodyTextView.isEditable = false
        incompleteView.addSubview(bodyTextView)
        return incompleteView
    }
    
    fileprivate func setUpCanvas4(_ x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let incompleteView = commonSetUpCodeCanvas(x, headerTitle: headerTitle)
        let textView = UITextView(frame: CGRect(x: kLeftSidePadding, y: 45, width: self.view.frame.width-30, height: 100))
        textView.text = bodyText
        textView.isEditable = false
        textView.dataDetectorTypes = .address
        textView.font = UIFont(name: "NanumBarunGothic", size: 16.0)
        incompleteView.addSubview(textView)
        let churchDirectionsImageView = UIImageView(image: UIImage(named: "churchDirections"))
        churchDirectionsImageView.frame = CGRect(x: 0, y: textView.frame.height + 30, width: self.view.frame.width, height: 250)
        churchDirectionsImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AboutPIViewController.churchDirectionsImageViewTapped))
        churchDirectionsImageView.addGestureRecognizer(tapGestureRecognizer)
        
        incompleteView.addSubview(churchDirectionsImageView)
        return incompleteView
    }
    
    func churchDirectionsImageViewTapped() {
        let addressDictionary = [String(CNPostalAddressStreetKey): "165 West 86th Street, New York, NY 10024"]
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.787738, longitude: -73.974524), addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "In2 West Campus at West Park Presbyterian Church"
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    fileprivate func setUpHorizontalScrollView(_ viewWidth: CGFloat) {
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.contentSize = CGSize(width: viewWidth * 4, height: 200)
        horizontalScrollView.delegate = self
        horizontalScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: viewWidth, height: 200), animated: false)
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page : UInt = UInt(scrollView.contentOffset.x / pageWidth)
        segmentedControl.setSelectedSegmentIndex(page, animated: true)
    }
    
}
