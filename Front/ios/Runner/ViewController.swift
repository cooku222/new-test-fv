import UIKit
import DaumMap

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MTMapView(frame: self.view.bounds)
        mapView.daumMapApiKey = "f71c36399cf870fbd1f368ace67701b8" // 여기 API 키를 입력
        self.view.addSubview(mapView)
    }
}
