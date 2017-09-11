// Configuring the AWS SDK
var AWS = require('aws-sdk');
AWS.config.update({region: process.env.REGION});

function setAsgDesiredCapacity(asgName, desiredCapacity, callback) {

  var autoscaling = new AWS.AutoScaling();

  var params = {
    AutoScalingGroupName: asgName,
    DesiredCapacity: desiredCapacity,
    HonorCooldown: false
  };

  autoscaling.setDesiredCapacity(params, function(err, data) {
    if (err) {
      callback(null, '{"ack":"false","reason":' + JSON.stringify(err) + '}');
    } else {
      callback(null, '{"ack":"true"}');  // successful response
    }
  });
}

function startFactorio(asgName, callback) {
  setAsgDesiredCapacity(asgName, 1, function(err,data){callback(err,data)});
}

function stopFactorio(asgName, callback) {
  setAsgDesiredCapacity(asgName, 0, function(err,data){callback(err,data)});
}


exports.handler = function(event, context, callback) {
  if (event.token !== undefined && event.action !== undefined && event.token == process.env.AUTH_TOKEN) {
    if (event.action == "start") {
      startFactorio(process.env.ASG_NAME, function(err,data){callback(err,data)});
    } else if (event.action == "stop") {
      stopFactorio(process.env.ASG_NAME, function(err,data){callback(err,data)});
    } else {
      callback(null, '{"ack":"false","reason":"Action specified does not exist"}');
    }
  } else {
    callback(null, '{"ack":"false","reason":"Wrong token specified and/or missing action parameter."}');
  }
};


