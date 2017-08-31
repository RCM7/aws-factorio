#cloud-config
fqdn: ${hostname}.${dns_domain}
hostname: ${hostname}
manage_etc_hosts: true

write_files:
  - content: |
      #!/bin/bash
      echo "Attempting factorio game save restore..."
      duplicity restore ${s3_url} /opt/factorio --no-encryption &> /dev/null || echo "Failed! Skipping"
      echo "Spinning up factorio..."
      docker run -d -p 34197:34197/udp -p 27015:27015/tcp -v /opt/factorio:/factorio --name factorio --restart=always dtandersen/factorio:latest
    
    path: /opt/setup_factorio.sh
    permissions: '0755'

  - content: |
      */10 * * * * root duplicity /opt/factorio ${s3_url} --no-encryption

    path: /etc/cron.d/factorio_backups
    permissions: '0644'

runcmd:
  - /opt/setup_factorio.sh
