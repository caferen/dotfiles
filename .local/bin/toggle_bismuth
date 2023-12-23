#!/bin/bash

kwriteconfig5 --file kwinrc --group Plugins --key bismuthEnabled "$(
    case $(kreadconfig5 --file kwinrc --group Plugins --key bismuthEnabled) in
        "true")
            echo "false";;
        "false")
            echo "true";;
    esac
)"
qdbus org.kde.KWin /KWin reconfigure
