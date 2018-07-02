function getAllRides() {
    var ridecount;
    $("#rideCount").empty();
    uberContract.getRideCount(function (err, res) {
        if (!err) {
            ridecount = res;
            $("#rideCount").append("<div id='rideCount2'>" + ridecount + " </div>");
            for (var i = 0; i < ridecount; i++) {
                var k = i + 1;
                uberContract.getRide(k, function (err, res) {
                    if (!err) {
                        console.log(res);
                        var rideValue2 = web3.fromWei(res[5], 'ether');
                        var status = getStatus(res[6]);

                        $("#getAllRides").append(`<div class="panel-group">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" href="#collapse` + res[0] + `"> Ride` + res[0] + `</a>
                                </h4>
                        </div>
                        <div id="collapse` + res[0] + `" class="panel-collapse collapse">
                            <div id="panel` + res[0] + `" class="panel-body">
                                <ul>
                                    <li>Ride Id: ` + res[0] + `</li>
                                    <li>Driver Address: ` + res[1] + `</li>
                                    <li>Rider Address: ` + res[2] + `</li>
                                    <li>Pick Up Address: ` + res[3] + `</li>
                                    <li>Drop off Address: ` + res[4] + `</li>
                                    <li>Ride Value: ` + rideValue2 + ` ether</li>
                                    <li>Ride Status: ` + status + `</li>
                                </ul>
                            </div>
                        </div>
                        </div>
                        </div>`);
                        if (status == "Requested") {
                            $("#panel" + res[0]).append(`
                            <button  type="button" class="btn btn-default" onclick="payForRide(` + res[0] + `, ` + rideValue2 + `)">Pay for ride</button>`)
                        } else if (status == "Paid" && userAccount == res[1]) {
                            $("#panel" + res[0]).append(`
                            <button  type="button" class="btn btn-default" onclick="startRide(` + res[0] + `)">Start Ride</button>`)
                        }
                        else if ((status == "InProgress") && (userAccount == res[2] || userAccount == res[1])) {
                            $("#panel" + res[0]).append(`
                            <button  type="button" class="btn btn-default" onclick="completeRide(` + res[0] + `)">Complete</button>`)
                            $("#panel" + res[0]).append(`
                            <button  type="button" class="btn btn-default" onclick="cancelRide(` + res[0] + `)">Cancel</button>`)
                        }
                    } else {
                        console.log(err);
                    }
                });
            }
        } else {
            console.log(err);
        }
    });
}


function requestRide() {
        
    var driver = selectedDriver;
    var pickup = $("#addPickUp").val();
    var dropOff = $("#addDropOff").val();
    var distance = $("#addDistance").val();

    uberContract.requestRide(driver, pickup, dropOff, distance, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}

function payForRide(id, value) {
    var weiValue = web3.toWei(web3.toBigNumber(value), 'ether');
    uberContract.payForRide(id, { value: weiValue }, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}


function startRide(id) {
    uberContract.startRide(id, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}

function completeRide(id) {
    uberContract.completeRide(id, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });        
}