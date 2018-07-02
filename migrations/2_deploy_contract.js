const Uber_TCR = artifacts.require("Uber_TCR");
const Drivers = artifacts.require("Drivers");

//const drivers = [
//    "0x821aea9a577a9b44299b9c15c88cf3087f3b5544",
//"0x0d1d4e623d10f9fba5db95830f7d3839406c6af2",
//    "0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e"
//]

module.exports = function(deployer){
    deployer.deploy(Uber_TCR);
    deployer.deploy(Drivers);
};

  