pragma solidity ^0.4.24;

import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "contracts/Ownable.sol";

contract Drivers is Ownable{

    enum DriverStatus{Requested, Registered, NotRegistered, Failed, Pending}

    struct uberDriver{
        uint rating;
        string name;
        string car;
        DriverStatus status;
        uint index;
        uint numberOfRides;
    }
    
    address[] public driversList;
    address[] public registeredDriverList;
    mapping (address => uberDriver) public uberdrivers;    
    uint numberOfDrivers; 
    event driverEvents(address driver, uint rating, string name, string car, uint status);
    address private uberContract = 0x345ca3e014aaf5dca488057592ee47305d9b3e10;  


    modifier isUberContract(address _contractAddress){
        require(msg.sender == uberContract, "Only the uber contract can call this funciton");
        _;
    }

    function isUser(address _driver)public view returns(bool isIndeed){
        if(driversList.length == 0) return false;
        return (driversList[uberdrivers[_driver].index] == _driver);
    }

    function rateDriver(address _driver, uint _rating)public  isUberContract(msg.sender){
        uberdrivers[_driver].numberOfRides++; 
        uint currentRating = uberdrivers[_driver].rating; 
        uint noRides = uberdrivers[_driver].numberOfRides;
        uint currentRatingVal = SafeMath.mul((noRides-1),currentRating);
        uint newRatingTotalVal = SafeMath.add(currentRatingVal, _rating);
        uint newRating = SafeMath.div(newRatingTotalVal, noRides);
        uberdrivers[_driver].rating = newRating;
        emit driverEvents(_driver, newRating, uberdrivers[_driver].name, uberdrivers[_driver].car, uint(uberdrivers[_driver].status));
    }

    function setUberContract(address _contract) onlyOwner public{
        uberContract = _contract;
    }  
    
    function requestToBeDriver(string _name, string _car) public{ 
        if(isUser(msg.sender)) revert("Driver Already Exisists"); 
        uberdrivers[msg.sender] = uberDriver(0, _name, _car, DriverStatus.Requested, driversList.push(msg.sender)-1,0);        
        emit driverEvents(msg.sender, 0, _name, _car, uint(DriverStatus.Registered));

    }
    function addDriver(address _driver, string _car, string _name) public onlyOwner returns(bool){
        if(isUser(_driver)) revert("Driver Already Exisists"); 
        uberdrivers[_driver] = uberDriver(0, _name, _car, DriverStatus.Registered, driversList.push(_driver)-1, 0);        
        registeredDriverList.push(_driver);
        return true; 
   //     emit driverEvents(_driver, 0, _name, _car, uint(DriverStatus.Registered));
    }

    function removeDriver(address _driver) public onlyOwner{
        if(!isUser(_driver)) revert("driver does not exisits");         
        
        uint rowToDelete = uberdrivers[_driver].index;
        address keyToMove = driversList[driversList.length-1];        
        driversList[rowToDelete] = keyToMove;
        uberdrivers[keyToMove].index = rowToDelete;
        driversList.length--;        
       
    }

    function getDriverCount() public view returns(uint){
        return driversList.length;
    }

    function getDriverAtIndex(uint _index) public view returns(address){
        return driversList[_index];
    }
 
    function getAllDriver() public view returns(address[]){
        return driversList;
    }

    function getDriverDetails(address _driver) public view returns(address,string,string,uint,uint,uint){
        string memory name = uberdrivers[_driver].name;
        string memory car = uberdrivers[_driver].car;
        uint rating = uberdrivers[_driver].rating;
        uint status = uint(uberdrivers[_driver].status);
        uint index = uberdrivers[_driver].index;
        return(_driver,name,car,rating,status,index);
    }
    
    function reviewDriver(address _driverAddress, string _returnStatus) onlyOwner public returns(string){
        
        string memory message;
        if(keccak256(_returnStatus) == keccak256("Approved"))
        {
            uberdrivers[_driverAddress].status = DriverStatus.Registered;
            registeredDriverList.push(_driverAddress);
            message = "Successfully registered, you can start driving";
        }else if(keccak256(_returnStatus) == keccak256("Pending")){
            uberdrivers[_driverAddress].status = DriverStatus.Pending;
            message = "We need some more time. Thanks";
        }else if(keccak256(_returnStatus) == keccak256("Rejected")){
            uberdrivers[_driverAddress].status = DriverStatus.Failed;            
            message = "Sorry, you don't meet our conditions";
        }else{
            uberdrivers[_driverAddress].status = DriverStatus.NotRegistered;
            message = "Still not registred";
        }
        string memory name = uberdrivers[_driver].name;
        string memory car = uberdrivers[_driver].car;
        uint rating = uberdrivers[_driver].rating;
        emit driverEvents(_driverAddress, rating, name, car, uint(DriverStatus.Requested));
        return message;
    }
}