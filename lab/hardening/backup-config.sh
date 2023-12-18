#!/bin/bash

mkdir /backups/

echo -e "#!/bin/bash\n\n\
SOURCE_DIR=\"~/\"\n\
DEST_DIR=\"/backups/\"\n\
TIMESTAMP=\$(date +%Y%m%d%H%M%S)\n\n\
rsync -a --delete \$SOURCE_DIR \$DEST_DIR/backup_\$TIMESTAMP\n\
tar czf \$DEST_DIR/snapshot_\$TIMESTAMP.tar.gz -C \$DEST_DIR backup_\$TIMESTAMP\n\
find \$DEST_DIR -type d -name \"backup_*\" -mtime +3 -exec rm -r {} \;" > backup_script.sh

chmod +x backup_script.sh

# Schedule backup_script.sh to run daily
echo "0 0 * * * /path/to/backup_script.sh" | crontab -