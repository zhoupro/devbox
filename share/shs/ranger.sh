sudo apt install -y ranger libxext-dev 
pip3 install  ueberzug

cat <<'EOF' > ~/.config/ranger/rc.conf
set preview_images true
set preview_images_method ueberzug
EOF
