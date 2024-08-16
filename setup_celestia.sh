exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check and install curl if necessary
if exists curl; then
  echo 'curl is already installed.'
else
  sudo apt-get update && sudo apt upgrade && sudo apt-get install curl screen -y < "/dev/null"
fi

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install tar wget aria2 clang pkg-config libssl-dev jq build-essential git make ncdu -y

# Set Go version
ver="1.22.0"

# Download and install Go
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"

# Set up Go environment
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Verify Go installation
go version

# Clone and build Celestia node
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.14.1
make build
make install
make cel-key

# Verify Celestia installation
celestia version

echo "Celestia node setup completed successfully!"
