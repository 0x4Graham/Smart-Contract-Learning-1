const Uber_TCR = artifacts.require("Uber_TCR");
const Drivers = artifacts.require("Drivers");

module.exports = function(deployer){
    deployer.deploy(Uber_TCR);
    deployer.deploy(Drivers);
};

  