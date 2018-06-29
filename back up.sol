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