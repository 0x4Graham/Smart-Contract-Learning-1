

function checkDriverStatus(val) {
    var driverstatus;

    switch (val) {
        case 0:
            driverstatus = "Requested";
            break;
        case 1:
            driverstatus = "Registered";
            break;
        case 2:
            driverstatus = "NotRegistered";
            break;
        case 3:
            driverstatus = "Failed";
            break;
        case 4:
            driverstatus = "Pending";
            break;
    }
    return driverstatus;
}





