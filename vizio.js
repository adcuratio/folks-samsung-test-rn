

module.exports.viziosearch = function () {
    window.devices = [];
    var NativeControllerModule = require('react-native').NativeModules.NativeControllerModule;
    var localDevices = [];
    NativeControllerModule.localDevices(
        "SEARCH LOCAL DEVICES",
        async (err, result) => {
            console.log(result)
            result = result.map((elem) => {
                return `https://${elem}`
            })
            localDevices = [...result];
            // localDevices.push("https://self-signed.badssl.com")
            alert(localDevices);
            for (var i = 0; i < localDevices.length; i++) {
                console.log(`${localDevices[i]}/state/device/power_mode`);
                NativeControllerModule.makesslcall(
                    `${localDevices[i]}/state/device/power_mode`,
                    async (err, result) => {
                        console.log(result);
                        if (result[0].success) {
                            alert("FOUND VIZIO TV--" + result[0].ip);
                            result = result[0];
                            window.devices.push({
                                name: result.name ? result.name : `Family Room TV`,
                                ip: result.ip,
                                desUrl: result.ip,
                                manufacturer: result.manufacturer ? result.manufacturer : "VIZIO",
                                modelName: result.model ? result.model : "VIZIO TV",
                                server: result.ip,
                                isSupported: false
                            })
                            console.log(window.devices);
                            //window.deviceFound();
                        }
                    });
            }
        });
}