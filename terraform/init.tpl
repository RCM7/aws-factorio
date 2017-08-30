#cloud-config
fqdn: ${hostname}.${dns_domain}
hostname: ${hostname}
manage_etc_hosts: true

write_files:
  - content: |
      #!/bin/bash
      echo "Spinning up factorio..."
      docker run -d -p 34197:34197/udp -p 27015:27015/tcp -v /tmp/factorio:/factorio --name factorio --restart=always dtandersen/factorio:latest
    path: /opt/setup_factorio.sh
    permissions: '0755'

runcmd:
  - /opt/setup_factorio.sh
