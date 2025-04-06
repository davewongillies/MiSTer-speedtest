# MiSTer-speedtest

[![Build MiSTer-speedtest](https://github.com/davewongillies/MiSTer-speedtest/actions/workflows/build_qrencode.yml/badge.svg)](https://github.com/davewongillies/MiSTer-speedtest/actions/workflows/build_qrencode.yml)

## What?

A simple script to install and run the [Ookla Speedtest CLI](https://www.speedtest.net/apps/cli)
on your MiSTer.

## How?

1. Add the following to `/media/fat/downloader.ini` on your MiSTer:

```ini
[davewongillies/MiSTer-speedtest]
db_url = https://raw.githubusercontent.com/davewongillies/MiSTer-speedtest/db/db.json.zip
```

2. Run `update` or `update_all` on your MiSTer to install this script
3. In the `Scripts` menu on the MiSTer run `speedtest`
