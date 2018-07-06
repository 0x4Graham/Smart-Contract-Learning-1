pragma solidity ^0.4.24;

import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "contracts/Ownable.sol";
import "contracts/Drivers.sol";

contract Uber_TCR is Ownable{
    
    using SafeMath for uint;
    enum RideStatus {NotStarted, Requested, Paid, InProgress, Completed, Cancelled, Rated}
    
    event RideEvent(uint rideId, address driver, address rider, string pickup, string dropoff, uint rideValue, uint status, bool CmD, bool CmR, 
    uint rating);
    event RideComplete(uint indexed rideId, address indexed driver, address indexed rider, uint rideValue);
    event RidePaid(uint indexed rideId, uint status);
    event FeeUpdated(uint newFee);
    
    struct Ride{
        address  rider; 
        address  driver;
        string pickUpLocation;
        string dropOffLocation;
        uint  distance;
        uint256  rideValue;        
        RideStatus status;
        bool rideCompleteDriver;
        bool rideCompleteRider;
        uint driveRating;
    }
    uint private numberOfRides;
    address[] public listDrivers; 
    mapping(uint => Ride) public rides;
    uint private contractAmount;
    uint public feePerKM = 0.001 ether;
    address public owner; 
    address private driverContract = 0xf25186b5081ff5ce73482ad761db0eb0d25abfbf;

    constructor() public{
        owner = msg.sender;
    }

    modifier isDriver(address _driverAddress){
        Drivers driver = Drivers(driverContract);
        bool isIndeed = driver.isUser(_driverAddress);
        require(isIndeed, "Only the uber contract can call this funciton");
        _;
    }

    function setdriverContract(address _contract) onlyOwner public{
        driverContract = _contract;
    }
        
    function setRideFee(uint256 _newFee) onlyOwner public{
        feePerKM = _newFee;
        emit FeeUpdated(_newFee);
    }

    function numOfDrivers() public view returns(uint256){
        return listDrivers.length;
    }
    
    function getAllDriver() public view returns(address[]){
        return listDrivers;
    }
    
    function getRideCount() public view returns(uint){
        return numberOfRides;
    }

    function getRide(uint _rideId) public view returns(uint, address, address,uint, uint,uint)
    {        
        address driver = rides[_rideId].driver;
        address rider = rides[_rideId].rider;
        uint value = rides[_rideId].rideValue;
        uint status = uint(rides[_rideId].status);
        uint rating = uint(rides[_rideId].driveRating);
        return(_rideId, driver, rider, value, status, rating);
    }
    function getRideLocationDetails(uint _rideId) public view returns(string, string){
        string memory pickup = rides[_rideId].pickUpLocation;
        string memory droppOff = rides[_rideId].dropOffLocation;
        return(pickup, droppOff);
    }
    function requestRide(address _driver, string _pickUpLocation, string _dropOffLocation, uint _distance) public {
        Drivers driver = Drivers(driverContract);
        bool isIndeed = driver.isUser(_driver);
        if(isIndeed){
            numberOfRides++;
            uint _rideId = numberOfRides;
            address _rider = msg.sender;
            uint256 _rideValue = SafeMath.mul(_distance, feePerKM);
            rides[_rideId] = Ride(_rider, _driver, _pickUpLocation, _dropOffLocation, _distance, _rideValue, RideStatus.Requested, false, false, 0);
            emit RideEvent(_rideId, _driver, _rider, _pickUpLocation, _dropOffLocation, _rideValue, uint(RideStatus.Requested), false, false, 0);
        }
        else{
            revert("Driver does not exist");
        }
        
    }

    function payForRide(uint _rideId) public payable{
        
        require(rides[_rideId].status == RideStatus.Requested, "Ride not in the correct state");
        
        contractAmount+= msg.value;
        if(msg.sender == rides[_rideId].rider) {
            if(msg.value == rides[_rideId].rideValue)
            {
                rides[_rideId].status = RideStatus.Paid;
                emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), false, false, 0);
            }
            else{
                revert("Incorrect Amount");
            }
        }  
    }

    function startRide(uint _rideId) public {
        require(rides[_rideId].status == RideStatus.Paid, "Ride has not been paid for yet");
        if(msg.sender == rides[_rideId].driver)
        {
            rides[_rideId].status = RideStatus.InProgress;
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), false, false, 0);

        }else{
            revert("Not driver");
        }
    }
    
    function cancelRide(uint _rideId) public{
        address _driver = rides[_rideId].driver;
        address _rider = rides[_rideId].rider;

        if(msg.sender == _driver)
        {
            rides[_rideId].status = RideStatus.Cancelled;
            _rider.transfer(rides[_rideId].rideValue);
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), false, false, 0);

        }else if(msg.sender == _rider)
        {
            rides[_rideId].status = RideStatus.Cancelled;
            _rider.transfer(rides[_rideId].rideValue * 95 / 100);
            //pay pentatly for cancellings
            _driver.transfer(rides[_rideId].rideValue * 5 / 100);
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status),false, false, 0);

        }
    }

    function completeRide(uint _rideId) public{
        
        
        address _driver = rides[_rideId].driver;
        address _rider = rides[_rideId].rider;

        if(msg.sender == _driver && rides[_rideId].rideCompleteDriver == false)
        {
            rides[_rideId].rideCompleteDriver = true;        
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), rides[_rideId].rideCompleteDriver, rides[_rideId].rideCompleteRider, 0);

        }else if(msg.sender == _rider && rides[_rideId].rideCompleteRider == false)
        {
            rides[_rideId].rideCompleteRider = true;                        
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), rides[_rideId].rideCompleteDriver, rides[_rideId].rideCompleteRider, 0);
        }
        else{
            revert("Woops");
        }

        if(rides[_rideId].rideCompleteDriver && rides[_rideId].rideCompleteRider)
        {
            _driver.transfer(rides[_rideId].rideValue);        
            rides[_rideId].status = RideStatus.Completed;   
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), true, true, 0);
        }
    }

    function rateRide(uint _rideId, uint _rating) public{
        address _driver = rides[_rideId].driver;        
        if(rides[_rideId].rideCompleteDriver && rides[_rideId].rideCompleteRider){
            rides[_rideId].driveRating = _rating;
            rides[_rideId].status = RideStatus.Rated;   
            Drivers driver = Drivers(driverContract);
            driver.rateDriver(_driver, _rating);
            emit RideEvent(_rideId, rides[_rideId].driver, rides[_rideId].rider, rides[_rideId].pickUpLocation, rides[_rideId].dropOffLocation, rides[_rideId].rideValue, uint(rides[_rideId].status), true,true, rides[_rideId].driveRating);
        }else
        {
            revert("Error");
        }
            

    }

    function statusOfRide(uint _rideId) public view returns(string){ 
        Ride storage ride = rides[_rideId];
        
        if(ride.status == RideStatus.Requested){
            return "Requested";
         }else if(ride.status == RideStatus.InProgress){
            return "In Progress";
         }else if(ride.status == RideStatus.NotStarted){
            return "Not Started";
         }else if(ride.status == RideStatus.Completed){
            return "Completed";             
         }else if(ride.status == RideStatus.Cancelled){
            return "Cancelled"; 
         }else if(ride.status == RideStatus.Paid){
            return "Paid"; 
         }
         else
         {
            return "cannot find ride";
         }
    }
}