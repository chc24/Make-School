
import UIKit
import CoreLocation
class CampusTableViewController: UITableViewController {
    
    var nearByVenues:[[String:AnyObject]]!
    
    private var tempPlace:NSString! {
        didSet{
            currentDisplayLocation.text = tempPlace as! String
        }
    }
    private var newWordField: UITextField!
    
    @IBOutlet weak var currentDisplayLocation: UILabel!
    @IBOutlet var campusTableView: UITableView!
    @IBOutlet weak var coordinates: UILabel!
    
    private struct StoryBoard {
        static let returnSegue = "returnSegue"
        static let locationCell = "locationCell"
    }
    
    private var selected: Int!
    

    // MARK: VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinates.text = "Coordinates"
        self.navigationItem.title = "Select Current Location"
        self.navigationItem.hidesBackButton = true
    }
    
    
    // MARK: - Custom Location
    
    private func add(){
        var alert = UIAlertController(title: "Custom Location", message: "Enter your current location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:wordEntered))
        self.presentViewController(alert, animated: true) {}
    }
    
    private func configurationTextField(textField: UITextField!){
        textField.placeholder = "Place"
        self.newWordField = textField
    }
    
    
    private func wordEntered(alert: UIAlertAction!){
        var textView2 = self.newWordField.text
        if textView2 != ""{
            println("You selected location: \(textView2)")
            self.tempPlace = "\(textView2)"
            self.currentDisplayLocation.text =  self.tempPlace as! String
        }
        self.performSegueWithIdentifier(StoryBoard.returnSegue, sender: self)
    }
    
    private func handleCancel(alertView: UIAlertAction!){
        println("User click Cancel button")
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearByVenues.count + 1  //Plus one for the custom cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(StoryBoard.locationCell) as! UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Custom"
        } else{
            cell.textLabel?.text = nearByVenues[indexPath.row - 1]["location"] as? String
        }
        
        //Colorize the cells
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        
        let increment = 0.3 + (CGFloat(indexPath.row))/20
        let rowLimit = 10
        
        if indexPath.row < rowLimit {
            cell.backgroundColor = UIColor(red: 0.5, green: increment, blue: 0.9, alpha: 1.0)
        } else{
            let tempRed:CGFloat =  (CGFloat(indexPath.row-rowLimit))/20
            var redIncrement:CGFloat = 0.5 - tempRed
            cell.backgroundColor = UIColor(red: redIncrement, green: CGFloat(CGFloat(rowLimit)/20+0.3)-tempRed, blue: 0.9, alpha: 1.0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            self.selected = -1
            add()
        } else {
            let location = self.nearByVenues[indexPath.row - 1]["location"] as! String
            println("You selected location: \(location)")
            
            tempPlace = "\(location)"
            tempPlace = "\(location)"
            selected = indexPath.row - 1
            self.performSegueWithIdentifier(StoryBoard.returnSegue, sender: self)
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == StoryBoard.returnSegue {
            
            if let mvc = segue.destinationViewController.contentViewController as? MainViewController {
                
                mvc.custom = true
                if self.selected != -1 {
                    
                    mvc.custom = false
                    let dic = self.nearByVenues[selected]
                    mvc.passLong  = dic["long"] as! Double
                    mvc.passLat = dic["lat"] as! Double
                }
                mvc.currentPlace = self.tempPlace as! String
            }
            
        }
    }
    
    
}
