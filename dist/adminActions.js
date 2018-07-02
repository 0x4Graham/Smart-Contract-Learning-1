function checkFeePerKM() {
    uberContract.feePerKM(function (err, res) {
        if (!err) {
            var feePerKM = web3.fromWei(res, 'ether');
            $("#rideFee").empty();
            $("#rideFee2").empty();
            $("#rideFee").append(`Ride Fee: ` + feePerKM + ` ether`);
            $("#rideFee2").append(`Ride Fee: ` + feePerKM + ` ether`);
        } else {
            console.log(err);
        }
    })
}

function checkOwner() {
    uberContract.owner(function (err, res) {
        if (!err) {
            owner = res;
        } else {
            console.log(err);
        }
    });
}

function adminActions() {
    if (userAccount != owner) {
        $("#adminTab").hide();
        $("#adminNav").hide();
    } else if (userAccount == owner) {
        $("#adminTab").show();
        $("#adminNav").show();
    }
    else {
        $("#adminTab").hide();
        $("#adminNav").hide();
    }
}


function updateFeePerKM() {
    var newFee = $("#addNewFee").val();
    var weiVal = web3.toWei(newFee, 'ether');
    uberContract.setRideFee(weiVal, function (err, res) {
        if (!err) {
            console.log(res);
        } else
            console.log(err);
    });
}