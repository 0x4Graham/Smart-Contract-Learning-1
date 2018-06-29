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
        address loan;
        DriverStatus status;
        uint index;
    }
    
    address[] public driversList;
    mapping (address => uberDriver) public uberdrivers;    
    uint numberOfDrivers; 
    event driverRegistered(address driver, uint rating, string name, string car, uint status);
    address private uberContract;    

    modifier isUberContract(address _contractAddress){
        require(msg.sender == uberContract, "Only the uber contract can call this funciton");
        _;
    }

    function isUser(address _driver)public returns(bool isIndeed){
        if(driversList.length == 0) return false;
        return (driversList[uberdrivers[_driver].index] == _driver);
    }

    function setUberContract(address _contract) onlyOwner public{
        uberContract = _contract;
    }

    function addDriver(address _driver, string _car, string _name, address _loan) public onlyOwner{
        if(isUser(_driver)) revert("Driver Already Exisists"); 
        uberdrivers[_driver] = uberDriver(0, _name, _car, _loan, DriverStatus.Registered, driversList.push(_driver));        
        emit driverRegistered(_driver, 0, _name, _car, uint(DriverStatus.Registered));
    }

    function addDriver(address _driver) public onlyOwner{
        if(!isUser(_driver)) revert("driver does not exisits");         
        uint rowToDelete = uberdrivers[_driver].index;
        address keyToMove = driversList[driversList.length-1];
        driversList[rowToDelete] = keyToMove;
        uberdrivers[keyToMove].index = rowToDelete;
        driversList.length--;        
        uberdrivers[_driver] = uberDriver(0, _name, _car, _loan, DriverStatus.Registered, driversList.push(_driver));        
        emit driverRegistered(_driver, 0, _name, _car, uint(DriverStatus.Registered));
    }

    function getDriverCount() public view returns(uint){
        return driversList.length;
    }

    function getDriverAtIndex(uint _index) public view returns(address){
        return driversList[_index];
    }
}