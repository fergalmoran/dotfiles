#!/usr/bin/bash
#unison -auto -batch -prefer newer -times=true /home/fergalm/dev/ /mnt/niles/dev/
rsync --archive \
      --delete \
      --progress \
      --human-readable \
      --exclude node_modules \
      ~/dev \
      /mnt/niles/sharing/backups/frasier_nightly/dev
