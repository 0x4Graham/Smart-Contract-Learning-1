function fillDriver(id) {
    $("#addDriver").val(listOfDrivers[id - 1]);
    selectedDriver = listOfDrivers[id - 1];
}

var allDrivers = [];
var driversRequested = [];
function getAllDriver() {
    $("#drivers").empty();
    $("#addressListReview").empty();
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
            var requestVal = 0;
            DriverContract.getDriverDetails(addressVal, function (err1, res2) {
                if (!err) {
                    allDrivers.push(res2);
                    //console.log(i);                 
                    if (checkDriverStatus(res2[4]) == "Registered") {
                        $("#drivers").append("<div id='driver" + newVal + "'class='driver' onclick='fillDriver(" + newVal + ")'> <p> Address: "
                            + res2[0] + "</p><p>Name: " + res2[1] + "</p><p> Car: " + res2[2] + "</p><p>Rating: " + res2[3] + "</p></div>");
                        newVal++;
                    }else if(checkDriverStatus(res2[4]) == "Requested"){
                        driversRequested.push(res2);
                        selectDriverToBeReviewd = 0;
                        $("#addressListReview").append(`<option value=` + requestVal + `>` + res2[0] + `</option>`);
                        requestVal++;
                        $("#reviewDriverAddress").empty();
                        $("#reviewDriverAddress").append(`<b>` + driversRequested[0][0] + `</b>`);
                        $("#reviewDriverName").empty();
                        $("#reviewDriverName").append(`<b>` + driversRequested[0][1] + `</b>`);
                        $("#reviewDriveCar").empty();
                        $("#reviewDriveCar").append(`<b>` + driversRequested[0][2] + `</b>`);
                    }
                    console.log(allDrivers);
                } else {
                    console.log(err);
                }
            })

        }
    });
}

var selectDriverToBeReviewd;
function loadRequestedDetails(val){
    var id = val.value;
    selectDriverToBeReviewd = id;
    $("#reviewDriverAddress").empty();
    $("#reviewDriverAddress").append(`<b>` + driversRequested[id][0] + `</b>`);
    $("#reviewDriverName").empty();
    $("#reviewDriverName").append(`<b>` + driversRequested[id][1] + `</b>`);
    $("#reviewDriveCar").empty();
    $("#reviewDriveCar").append(`<b>` + driversRequested[id][2] + `</b>`);

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


function addDriverAdmin() {
    var addressDriver = $("#addAdminDriverAddress").val();
    var name = $("#addAdminDriverName").val();
    var car = $("#addAdminDriverVehicle").val();
    DriverContract.addDriver(addressDriver,car,name, function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}


function reviewDriver() {
    var addDriver =  driversRequested[selectDriverToBeReviewd][0];
    var status = $("#reviewOption").val();
    DriverContract.reviewDriver(addDriver,status,function (err, res) {
        if (!err)
            console.log(res)
        else
            console.log(err);
    });
}


