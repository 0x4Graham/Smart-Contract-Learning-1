pragma solidity ^0.4.23;

import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol";



contract Uber_TCR {

    enum RideStatus {NotStarted, Requested, InProgress, Completed, Cancelled }
    event RideCreation(uint indexed rideId, address indexed driver, address indexed rider, uint rideValue);
    event RideComplete(uint indexed rideId, address indexed driver, address indexed rider, uint rideValue);

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
    }
    address[] public listDrivers; 
    mapping(uint => Ride) public rides;
    ERC20 public currency;
    address public escrowAccount;

    constructor(ERC20 _currency, address[] _drivers) public{
        currency = _currency;
        escrowAccount = msg.sender; 
        listDrivers = _drivers; 
        escrowAccount = msg.sender;
    }
   
    function requestRide(uint _rideId, address _rider, address _driver, string _pickUpLocation, string _dropOffLocation, uint _distance) public{
        uint256 _rideValue = _distance * 1 / 1000;
        rides[_rideId] = Ride(_rider, _driver, _pickUpLocation, _dropOffLocation, _distance, _rideValue, RideStatus.NotStarted, false, false);
        emit RideCreation(_rideId, _rider, _driver, _rideValue);
    }

    function payForRide(uint _rideId) public payable{
        if(msg.sender == rides[_rideId].rider) {
            if(msg.value == rides[_rideId].rideValue)
            {
                rides[_rideId].status = RideStatus.Requested;
            }
        }  
    }

    function startRide(uint _rideId) public {
        
        if(msg.sender == rides[_rideId].driver)
        {
            rides[_rideId].status = RideStatus.InProgress;
        }
        revert("Not driver");
    }
    
    function cancelRide(uint _rideId) public{
        
        address _rider = rides[_rideId].rider;
        address _driver = rides[_rideId].driver;

        if(msg.sender == _driver)
        {
            rides[_rideId].status = RideStatus.Cancelled;
            currency.transfer(_rider,  rides[_rideId].rideValue);
        }else if(msg.sender == rides[_rideId].rider)
        {
            rides[_rideId].status = RideStatus.Cancelled;
            currency.transfer(_rider,  rides[_rideId].rideValue * 95 / 100);
            //pay pentatly for cancellings
            currency.transfer(_driver,  rides[_rideId].rideValue * 5 / 100);
        }
        else{
            revert("woops");
        }
    }
    
    function completeRide(uint _rideId) public{
        address _rider = rides[_rideId].rider;
        address _driver = rides[_rideId].driver;
           
           
        if(msg.sender == _driver)
        {
            rides[_rideId].rideCompleteDriver = true;
        }else if(msg.sender == _rider){
            rides[_rideId].rideCompleteRider = true;
        }
        
        if(rides[_rideId].rideCompleteDriver && rides[_rideId].rideCompleteRider)
        {
           currency.transfer(_driver,  rides[_rideId].rideValue);
        }
    }
}
