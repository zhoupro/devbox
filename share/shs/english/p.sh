if [ !  -f "prodict/$1.mp3" ]; then
    ffmpeg -i pronounce/z_$1__gb_*.wav prodict/$1.mp3
fi

VLC --input-repeat=1 --play-and-exit  prodict/$1.mp3
