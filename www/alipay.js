var exec = require('cordova/exec');

module.exports = {
  pay: function(payInfo,onSuccess,onError){
    exec(onSuccess, onError, "Alipay", "pay", [payInfo]);
  }
};


