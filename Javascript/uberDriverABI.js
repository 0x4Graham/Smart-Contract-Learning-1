var uberDriversABI = [
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
		"inputs": [],
		"name": "renounceOwnership",
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
				"name": "status",
				"type": "string"
			}
		],
		"name": "DriverAccessRequested",
		"type": "event"
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
	}
];