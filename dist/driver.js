function fillDriver(id) {
    $("#addDriver").val(listOfDrivers[id - 1]);
    selectedDriver = listOfDrivers[id - 1];
}


function getAllDriver() {
    $("#drivers").empty();
    DriverContract.getAllDriver(function (err, res) {
        if (!err) {
            listOfDrivers = res;
        } else {
            console.log(err);
        }

        var numDrivers = listOfDrivers.length;
        for (var i = 0; i < numDrivers; i++) {
            var addressVal = web3.toBigNumber(listOfDrivers[i]);
            var newVal = 1;
            DriverContract.getDriverDetails(addressVal, function (err1, res2) {
                if (!err) {
                    //console.log(i);

                    $("#drivers").append("<div id='driver" + newVal + "'class='driver' onclick='fillDriver(" + newVal + ")'> <p> Address: "
                        + res2[0] + "</p><p>Name: " + res2[1] + "</p><p> Car: " + res2[2] + "</p><p>Rating: " + res2[3] + "</p></div>");
                    newVal++;
                } else {
                    console.log(err);
                }
            })

        }
    });
}

function requestToBeDriver() {

    var name = $("#addDriverName").val();
    var car = $("#addDriverVehicle").val();

    DriverContract.requestToBeDriver(name, car, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}