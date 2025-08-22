# apt-update-hook
 Apt update hook that wil ask if user wants to update or not

![deb-get-apt-hook.gif](https://github.com/tmiland/apt-update-hook/blob/main/res/apt-update-hook.png?raw=true)

## Install
 - Latest release
 ```bash
 git clone https://github.com/tmiland/apt-update-hook.git ~/.apt-update-hook && \
 cd ~/.apt-update-hook && \
 git fetch --tags && \
 release="$(git describe --tags "$(git rev-list --tags --max-count=1)")" && \
 git checkout $release && \
 ./install.sh -i
 ```

 - Main
 ```bash
 git clone https://github.com/tmiland/apt-update-hook.git ~/.apt-update-hook && \
 cd ~/.apt-update-hook && \
 ./install.sh -i
 ```

 - Update
 ```bash
 cd ~/.apt-update-hook && \
 git pull && \
 ./install.sh -r
 ```

 ## Donations
 <a href="https://coindrop.to/tmiland" target="_blank"><img src="https://coindrop.to/embed-button.png" style="border-radius: 10px; height: 57px !important;width: 229px !important;" alt="Coindrop.to me"></img></a>

 ### Disclaimer 

 *** ***Use at own risk*** ***

 ### License

 [![MIT License Image](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/220px-MIT_logo.svg.png)](https://tmiland.github.io/apt-update-hook/LICENSE)

 [MIT License](https://tmiland.github.io/apt-update-hook/LICENSE)