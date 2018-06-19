var uberContractABI = [
	{
		"constant": true,
		"inputs": [],
		"name": "feePerKM",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_rideId",
				"type": "uint256"
			}
		],
		"name": "payForRide",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_driverAddress",
				"type": "address"
			},
			{
				"name": "_returnStatus",
				"type": "string"
			}
		],
		"name": "reviewDriver",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "rides",
		"outputs": [
			{
				"name": "rider",
				"type": "address"
			},
			{
				"name": "driver",
				"type": "address"
			},
			{
				"name": "pickUpLocation",
				"type": "string"
			},
			{
				"name": "dropOffLocation",
				"type": "string"
			},
			{
				"name": "distance",
				"type": "uint256"
			},
			{
				"name": "rideValue",
				"type": "uint256"
			},
			{
				"name": "status",
				"type": "uint8"
			},
			{
				"name": "rideCompleteDriver",
				"type": "bool"
			},
			{
				"name": "rideCompleteRider",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "uberdrivers",
		"outputs": [
			{
				"name": "rating",
				"type": "uint256"
			},
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "car",
				"type": "string"
			},
			{
				"name": "status",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_driver",
				"type": "address"
			},
			{
				"name": "rating",
				"type": "uint256"
			}
		],
		"name": "rateDriver",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_rideId",
				"type": "uint256"
			}
		],
		"name": "cancelRide",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_rideId",
				"type": "uint256"
			}
		],
		"name": "statusOfRide",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "listDrivers",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_rideId",
				"type": "uint256"
			}
		],
		"name": "completeRide",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_driver",
				"type": "address"
			},
			{
				"name": "_pickUpLocation",
				"type": "string"
			},
			{
				"name": "_dropOffLocation",
				"type": "string"
			},
			{
				"name": "_distance",
				"type": "uint256"
			}
		],
		"name": "requestRide",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_car",
				"type": "string"
			},
			{
				"name": "_name",
				"type": "string"
			}
		],
		"name": "requestToBeDriver",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_contract",
				"type": "address"
			}
		],
		"name": "setUberContract",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_newFee",
				"type": "uint256"
			}
		],
		"name": "setRideFee",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_rideId",
				"type": "uint256"
			}
		],
		"name": "startRide",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_drivers",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "rideId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"name": "driver",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "rider",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "rideValue",
				"type": "uint256"
			}
		],
		"name": "RideCreation",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "rideId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"name": "driver",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "rider",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "rideValue",
				"type": "uint256"
			}
		],
		"name": "RideComplete",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "rideId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rider",
				"type": "address"
			}
		],
		"name": "RidePaid",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "uberAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "status",
				"type": "string"
			}
		],
		"name": "DriverAccessRequested",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "uberAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "message",
				"type": "string"
			}
		],
		"name": "DriverAccessReviewed",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "uberAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "rating",
				"type": "uint256"
			}
		],
		"name": "DriverRated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "previousOwner",
				"type": "address"
			}
		],
		"name": "OwnershipRenounced",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	}
];