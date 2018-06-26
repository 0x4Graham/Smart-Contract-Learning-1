pragma solidity ^0.4.24;

import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "contracts/Ownable.sol";

contract Drivers is Ownable{

    enum DriverStatus{Requested, Registered, NotRegistered, Failed, Pending}

    struct uberDriver{
        address driverAddress;
        uint rating;
        string name;
        string car;
        DriverStatus status;
    }
    
    uberDriver[] public uberdrivers;
   // mapping (uint => uberDriver) public uberdrivers;    
    uint numberOfDrivers; 
    event DriverAccessRequested(address indexed uberAddress, string indexed status);
    event DriverAccessReviewed(address uberAddress, string message);
    event DriverRated(uint _driverId, uint rating);

    address private uberContract;

    modifier isUberContract(address _contractAddress){
        require(msg.sender == uberContract, "Only the uber contract can call this funciton");
        _;
    }

    function setUberContract(address _contract) onlyOwner public{
        uberContract = _contract;
    }
    
    function getDriver(uint _driverId) public view returns(uint, address, string, string, uint){
        uberDriver storage uberdriver = uberdrivers[_driverId];
        return(_driverId, uberdriver.driverAddress, uberdriver.name, uberdriver.car, uberdriver.rating);
    }
    
    function getAllDrivers() external view returns(uint[]){
        uint[] memory result;
        uint counter = 0;

        for (uint i = 0; i < uberdrivers.length; i++) {
            result[counter] = i;
            counter++;
        }
        return result;
    }
    
    function requestToBeDriver(string _car, string _name) public returns(string){
        numberOfDrivers++;
        uberdrivers[numberOfDrivers] = uberDriver(msg.sender,0, _name, _car, DriverStatus.Requested);     
           
       // emit DriverAccessRequested(msg.sender, "Requested");
    }

    function reviewDriver(uint _driverID, address _driverAddress, string _returnStatus) onlyOwner public{
        
        string memory message;
        if(keccak256(_returnStatus) == keccak256("Approved"))
        {
            uberdrivers[_driverID].status = DriverStatus.Registered;
            message = "Successfully registered, you can start driving";
        }else if(keccak256(_returnStatus) == keccak256("Pending")){
            uberdrivers[_driverID].status = DriverStatus.Pending;
            message = "We need some more time. Thanks";
        }else if(keccak256(_returnStatus) == keccak256("Rejected")){
            uberdrivers[_driverID].status = DriverStatus.Failed;
            message = "Sorry, you don't meet our conditions";
        }else{
            uberdrivers[_driverID].status = DriverStatus.NotRegistered;
            message = "Still not registred";
        }
     //   emit DriverAccessReviewed(_driverAddress, message);
    }

    function rateDriver(uint _driverId, uint rating) public isUberContract(msg.sender){        
        uberdrivers[_driverId].rating = uberdrivers[_driverId].rating + rating;
  //      emit DriverRated(_driverId, uberdrivers[_driverId].rating);
    }
}