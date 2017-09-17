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

function getInstanceIP(instanceID, callback) {

  var ec2 = new AWS.EC2();

  var params = {
    InstanceIds: [
      instanceID
    ]
  };

  ec2.describeInstances(params, function(err, data) {
    callback(err,data);
  });
}

function statusFactorio(asgName, callback) {

  var autoscaling = new AWS.AutoScaling();

  var params = {
    AutoScalingGroupNames: [
      asgName
    ]
  };

  autoscaling.describeAutoScalingGroups(params, function(err, data) {
    if (err) {
      callback(null, '{"ack":"false","reason":' + JSON.stringify(err) + '}');
    } else {

      var instances = data.AutoScalingGroups[0].Instances;

      if (instances[0] === undefined){
        callback(null, '{"ack":"true","status":{"instance_ip":"-","instance_state":"No instances running"}}');
      } else {
        getInstanceIP(instances[0].InstanceId, function(err, ipData) {
          if (err) {
            callback(null, '{"ack":"false", "reason":' + JSON.stringify(err) + '}');
          } else {
              var ip = JSON.stringify(ipData.Reservations[0].Instances[0].PublicIpAddress)
              callback(null, '{"ack":"true", "status":{"instance_ip":'+ (ip === undefined ? '"-"' : ip) +', "instance_state":'+ JSON.stringify(instances[0].LifecycleState) +'}}');
          }
        })
      }
    }
  });
}

exports.handler = function(event, context, callback) {
  if (event.token !== undefined && event.action !== undefined && event.token == process.env.AUTH_TOKEN) {
    if (event.action == "start") {
      startFactorio(process.env.ASG_NAME, function(err,data){callback(err,data)});
    } else if (event.action == "stop") {
      stopFactorio(process.env.ASG_NAME, function(err,data){callback(err,data)});
    } else if (event.action == "status"){
      statusFactorio(process.env.ASG_NAME, function(err,data){callback(err,data)});
    } else {
      callback(null, '{"ack":"false","reason":"Action specified does not exist"}');
    }
  } else {
    callback(null, '{"ack":"false","reason":"Wrong token specified and/or missing action parameter."}');
  }
};


