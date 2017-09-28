# Factorio Packer

Packer scripts to create the Factorio base image.

## Requirements

 - Ansible - 2.3.1.0 - [Installation Docs](http://docs.ansible.com/ansible/latest/intro_installation.html)
 - Packer - 1.0.4 - [Installation Docs](https://www.packer.io/downloads.html)

## Configuration

Copy the `variables.json.sample` file and customize accordingly.

```
$ cp variables.json.sample variables.json
$ vim variables.json
$ cat variables.json
{
  "factorio_version": "0.15.34",
  "source_ami": "ami-d037cda9",
  "vpc_id": "vpc-4b797a6e",
  "subnet_id": "subnet-7a55445a"
}
```

## Usage

Install Ansible requirements:

```
$ ansible-galaxy install -r ./requirements.yml -p ./roles
```

Build Factorio image:

```
$ packer build -var-file=variables.json ./factorio.json
```
