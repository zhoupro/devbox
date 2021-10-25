#!/bin/bash

size(){
	x=$(xrandr| grep current | awk -F "," '{print $2}' | sed 's/current//g' | sed 's/x//g' | awk '{print $1}')
	y=$(xrandr| grep current | awk -F "," '{print $2}' | sed 's/current//g' | sed 's/x//g' | awk '{print $2}')

	[ $x -lt $y ]

}

