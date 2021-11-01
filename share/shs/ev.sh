#!/bin/bash
evtest /dev/input/event20 >> /tmp/keyboard &
evtest /dev/input/event2 >> /tmp/keyboard &
evtest /dev/input/event7 >> /tmp/keyboard &
