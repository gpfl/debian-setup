#! /bin/sh

FOLDER="zig-linux-x86_64-0.14.0" 
FILE="$FOLDER.tar.xz" 
LY_REPO='https://github.com/fairyglade/ly.git'

# install basic dependencies
sudo apt install -y build-essential libpam0g-dev libxcb-xkb-dev

# get zig_0_14_0 tarball
if [ ! -f "$FILE" ]; then
	wget "https://ziglang.org/download/0.14.0/$FILE"
	export PATH="$(pwd)/$FOLDER:$PATH"
fi

# untar zig_0_14_0
if [ ! -d "$FOLDER" ]; then
	tar -xf "$FILE"
fi

# get ly repo
if [ ! -d 'ly' ]; then
	echo "$LY_REPO"
	git clone --recurse-submodules "$LY_REPO"
fi 


deploy_ly() {
	cd ly || { echo "Failed to change directory to ly"; }
	zig build || { echo "Failed to execute zig build"; }
	sudo "$(dirname $(pwd))/$FOLDER"/zig build installexe || { echo "Failed to execute zig build instalexe"; }
	sudo cp /usr/lib/systemd/system/ly.service /etc/systemd/system || { echo "Failed to copy ly service to /etc/systemd"; }
	sudo systemctl enable --now ly.service || { echo "Failed to enable ly service"; }
}

# deploy ly
deploy_ly

# clean up
cd ..
rm -rf "$FOLDER"
rm "$FILE"
rm -rf 'ly'
