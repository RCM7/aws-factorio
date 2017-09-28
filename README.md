# AWS Factorio

Collection of Packer and Terraform scripts to deploy an instance of [Factorio](https://www.factorio.com) in AWS.

Blog post with thorough explanation of the code: [https://capsule.one/blog/2017/09/28/automating-infrastructure-playing-factorio-on-aws/](https://capsule.one/blog/2017/09/28/automating-infrastructure-playing-factorio-on-aws/)

## Provisioning AWS Resources

 - [Packer guide](packer/README.md)
 - [Terraform guide](terraform/README.md)

## Using factorio cli

First create your env file (or export directly on your terminal):

```
$ cp .env factorio.env
$ cat factorio.env
export FACTORIO_API_URL=
export FACTORIO_API_KEY=
export FACTORIO_AUTH_TOKEN=
$ vim factorio.env
```

The result should look like this:

```
export FACTORIO_API_URL=https://09yxn77opyu.execute-api.eu-west-1.amazonaws.com/factorio/manage/
export FACTORIO_API_KEY=DjH3vyWrQY9076MScTXuktGm55MKlu6jB8jHSw0tx
export FACTORIO_AUTH_TOKEN=KlYjIhacbfbbagKiQf1X6vCprsKsI8Faeyd6frREo8vxELwxDAwSWiKf0KKzTsOU
```
Now just run the script with the arguments `start`, `stop` or `status`:

```
$ source factorio.env
$ ./factorio --help
usage: factorio [-h] <action>

Manage factorio in AWS.

positional arguments:
  <action>    action to perform (start|stop|status)

optional arguments:
  -h, --help  show this help message and exit


$ ./factorio start
Factorio started successfully

$ ./factorio status
INSTANCE_IP				 STATE
52.18.164.155				 Pending

```
## Contributing

All feedback is welcome so please open a [Github issue](https://github.com/RCM7/aws-factorio/issues) should you encounter any problem.

Also be free to Fork and open a [Pull Request](https://github.com/RCM7/aws-factorio/pulls)!

## License

This work by [Ricardo Marques](https://capsule.one) is licensed under The MIT License.
