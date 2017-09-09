// Configuring the AWS SDK
var AWS = require('aws-sdk');
AWS.config.update({region: process.env.REGION});

exports.handler = function(event, context, callback) {

  var autoscaling = new AWS.AutoScaling();

  var params = {
    AutoScalingGroupName: process.env.ASG_NAME,
    DesiredCapacity: 1,
    HonorCooldown: false
  };

  autoscaling.setDesiredCapacity(params, function(err, data) {
    if (err) {
      callback(err)
      console.log(err, err.stack);       // an error occurred
    } else {
        callback(null, '{"ack":"true"}');  // successful response
    }
  });

};

