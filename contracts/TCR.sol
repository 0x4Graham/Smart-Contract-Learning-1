pragma solidity ^0.4.23;

import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol";

contract Uber_TCR {

    enum RideStatus {NotStarted, Requested, Paid, InProgress, Completed, Cancelled }
    event RideCreation(uint indexed rideId, address indexed driver, address indexed rider, uint rideValue);
    event RideComplete(uint indexed rideId, address indexed driver, address indexed rider, uint rideValue);

    struct Ride{
        address  rider; 
        address  driver;
        string pickUpLocation;
        string dropOffLocation;
        uint  distance;
        uint  rideValue;        
        RideStatus status;
        bool rideCompleteDriver;
        bool rideCompleteRider;
    }

    address[] public listDrivers; 
    mapping(uint => Ride) public rides;
    address public escrowAccount;
    uint public contractAmount;
    
    constructor(address[] _drivers) public{
        escrowAccount = msg.sender; 
        listDrivers = _drivers;         
    }
    
    function requestRide(uint _rideId, address _driver, string _pickUpLocation, string _dropOffLocation, uint _distance) public{
        address _rider = msg.sender;
        uint _rideValue = 20 ether;
        rides[_rideId] = Ride(_rider, _driver, _pickUpLocation, _dropOffLocation, _distance, _rideValue, RideStatus.Requested, false, false);
        emit RideCreation(_rideId, _rider, _driver, _rideValue);
    }

    function payForRide(uint _rideId) public payable{
        contractAmount+= msg.value;
        if(msg.sender == rides[_rideId].rider) {
            if(msg.value == rides[_rideId].rideValue)
            {
                rides[_rideId].status = RideStatus.Paid;
            }
            else{
                revert("Incorrect Amount");
            }
        }  
    }

    function startRide(uint _rideId) public {
        
        if(msg.sender == rides[_rideId].driver)
        {
            rides[_rideId].status = RideStatus.InProgress;
        }else
        {
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
        }else if(msg.sender == _rider)
        {
            rides[_rideId].status = RideStatus.Cancelled;
            _rider.transfer(rides[_rideId].rideValue * 95 / 100);
            //pay pentatly for cancellings
            _driver.transfer(rides[_rideId].rideValue * 5 / 100);
        }
    }

    function completeRide(uint _rideId) public{
        
        address _driver = rides[_rideId].driver;
        address _rider = rides[_rideId].rider;

        if(msg.sender == _driver)
        {
            rides[_rideId].rideCompleteDriver = true;            
        }else if(msg.sender == _rider)
        {
            rides[_rideId].rideCompleteRider = true;            
        }

        if(rides[_rideId].rideCompleteDriver && rides[_rideId].rideCompleteRider)
        {
            _driver.transfer(rides[_rideId].rideValue);        
            rides[_rideId].status = RideStatus.Completed;   
            emit RideComplete(_rideId, _driver, _rider, rides[_rideId].rideValue);
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