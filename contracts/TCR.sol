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
    }
    address[] public listDrivers; 
    mapping(uint => Ride) public rides;
    ERC20 public currency;
    address public escrowAccount;

    constructor(ERC20 _currency, address[] _drivers){
        currency = _currency;
        escrowAccount = msg.sender; 
        listDrivers = _drivers; 
        escrowAccount = msg.sender;
    }
   
    function requestRide(uint _rideId, address _rider, address _driver, string _pickUpLocation, string _dropOffLocation, uint _distance) public{
        uint256 _rideValue = _ditance * 0.001;
        rides[_rideId] = Ride(_rider, _driver, _pickUpLocation, _dropOffLocation, _distance, _rideValue, RideStatus.NotStarted);
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

    function startRide(uint _rideId, address _driver) public {
        
        if(msg.sender == rides[_rideId].driver)
        {
            rides[_rideId].status = PaymentStatus.InProgress;
        }
        revert("Not driver");
    }
    
    function cancelRide(uint _rideId){
        
    }

    function accept() public {
        if (msg.sender == rider){
            riderOk = true;
        } else if (msg.sender == seller){
            driverOk = true;
        }         
        if(msg.sender == rider && sellOk)
        {
            makePayment();      
        }
    }

    function makePayment() public {
        if(riderOk && driverOk)
        {
            currency.transfer(driver, rideValue);
        }
    }


    function cancel() public {
        if (msg.sender == rider) {
            riderOk = false;        
        }else if(msg.sender == driver)
        {
            driverOk = false; 
        }
        if(!riderOk && !drivrOk)
        {
            selfdestruct(rider);
        }
    }

    function kill() public view{
        if(msg.sender == escrow)
        {
            selfdestruct(driver);
        }
    }

}