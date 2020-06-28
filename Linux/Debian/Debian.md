# Debian

## 基本组件安装

```
sudo apt-get clean

sudo apt-get update

sudo apt-get dist-upgrade

sudo apt-get install \
curl wget apt-transport-https vim xclip tree rar zip unrar unzip p7zip net-tools 
```

## 字体

```
sudo apt-get install \
fonts-inconsolata \
fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy \
fonts-noto-core fonts-noto-extra \
fonts-noto-ui-core fonts-noto-ui-extra \
fonts-noto-hinted fonts-noto-unhinted \
fonts-noto-cjk fonts-noto-cjk-extra \
fonts-noto-color-emoji \
fonts-roboto fonts-roboto-hinted fonts-roboto-unhinted fonts-roboto-fontface fonts-roboto-slab \
fonts-ubuntu-title fonts-ubuntu fonts-ubuntu-console fonts-ubuntu-font-family-console 
```

## 常用软件

```
sudo apt-get install \
irssi irssi-plugin-otr irssi-plugin-xmpp irssi-scripts \
blender deluge deluge-torrent aria2 \
chromium chromium-l10n chromium-sandbox  chromium-ublock-origin \
```

## 编程

### C语言

```
sudo apt-get install git clang clang-format clang-tidy clang-tools make make-doc gdb gdb-doc cmake cmake-doc 
```

### IDE

#### codelite

```
sudo apt-key adv --fetch-keys http://repos.codelite.org/CodeLite.asc
sudo apt-add-repository 'deb https://repos.codelite.org/debian/ buster devel'
sudo apt-get update
sudo apt-get install codelite
```

### KDE

```
sudo apt-get install \
sddm-theme-breeze sddm-theme-elarun sddm-theme-maldives sddm-theme-maui sddm-theme-maya \
sddm-theme-debian-breeze sddm-theme-debian-elarun sddm-theme-debian-maui \
zsh zsh-autosuggestions zsh-syntax-highlighting zsh-antigen
```

### Gnome

```
sudo apt-get install \
gedit-source-code-browser-plugin rhythmbox-plugin-alternative-toolbar \
breeze-cursor-theme breeze-icon-theme numix-gtk-theme \
retext liferea
```

## Visual Studio Code

```
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get clean
sudo apt-get update
sudo apt-get install code
```

## git 配置

```
export git_name=YOU_GIT_NAME
export git_email=YOU_GIT_EMAIL
git config --global user.name "$git_name"
git config --global user.email "$git_email"
ssh-keygen -t rsa -b 4096 -C "$git_email"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

xclip -sel clip < ~/.ssh/id_rsa.pub
```

## vim 配置

```
sudo cp /etc/vim/vimrc /etc/vim/vimrc.backup

sudo chmod 777 /etc/vim/vimrc

sudo cat >> /etc/vim/vimrc << EOF

" 设定默认解码
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936

" 不要使用vi的键盘模式，而是vim自己的 
set nocompatible

" 语法高亮
syntax on

" 不要闪烁
set novisualbell

" 不让vim发出讨厌的滴滴声
set noerrorbells

" 在状态行上显示光标所在位置的行号和列号
set ruler
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)

" 状态行显示的内容
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" 总是显示状态行
set laststatus=2

" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2

" 不要备份文件
set nobackup

" 增强模式中的命令行自动完成操作
set wildmenu

" 侦测文件类型
filetype on

" 载入文件类型插件
filetype plugin on

" 为特定文件类型载入相关缩进文件
filetype indent on


" 搜索和匹配
" 高亮显示匹配的括号
set showmatch

" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=5

" 在搜索的时候忽略大小写
set ignorecase

" 不要高亮被搜索的句子（phrases）
set nohlsearch

" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch

" 文本格式和排版
" 自动格式化
set formatoptions=tcrqn

" 继承前一行的缩进方式，特别适用于多行注释
set autoindent

" 为C程序提供自动缩进
set smartindent

" 使用C样式的缩进
set cindent

" 制表符为4
set tabstop=4

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

" 不要用空格代替制表符
set noexpandtab

EOF

sudo chmod 644 /etc/vim/vimrc
```

## Go

```
sudo cp /etc/profile /etc/profile.backup

sudo chmod 777 /etc/profile

sudo cat >> /etc/profile  << EOF

################################################################################################
##                                              Go                                            ##
################################################################################################
export GOROOT=/usr/local/go
export PATH=\$PATH:\$GOROOT/bin

EOF

sudo chmod 644 /etc/profile

cat >> ~/.profile << EOF

################################################################################################
##                                              Go                                            ##
################################################################################################
export GOPATH=/source/go/env
export PATH=\$PATH:\$GOPATH/bin

EOF

```

## irssi

```
/set nick CloudFStrife
/set user_name CloudFStrife
/set real_name Cloud.F.Strife

/RUN scriptassist.pl

/script install awaybar
/script install nickcolor
/script install nicklist
/script install trackbar
/script install usercount
/script install smartfilter

/script autorun awaybar
/script autorun nickcolor
/script autorun nicklist
/script autorun trackbar
/script autorun usercount
/script autorun smartfilter

/server add -auto -network freenode -ssl -ssl_verify chat.freenode.net 7000
/network add -nick xxxxxxxx -user xxxxxxxx -realname xxxxxxxx -sasl_username xxxxxxxx -sasl_password xxxxxxxx -sasl_mechanism PLAIN freenode

/recode add * utf-8
/set autolog ON

/save
```

## ZSH

```
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.local/share/ohmyzsh
cp ~/.local/share/ohmyzsh/templates/zshrc.zsh-template ~/.zshrc 

sed -i 's?\$HOME/.oh-my-zsh?$HOME/.local/share/ohmyzsh?' ~/.zshrc
sed -i 's?ZSH_THEME="robbyrussell"?ZSH_THEME="agnoster"?' ~/.zshrc
sed -i 's?(git)?(git golang kubectl emoji emoji-clock docker nmap python)?' ~/.zshrc

chsh -s /bin/zsh 

```

### ZSH - Go

```
sudo cp /etc/zsh/zprofile /etc/zsh/zprofile.backup

sudo chmod 777 /etc/zsh/zprofile

sudo cat >> /etc/zsh/zprofile  << EOF

################################################################################################
##                                              Go                                            ##
################################################################################################
export GOROOT=/usr/local/go
export PATH=\$PATH:\$GOROOT/bin

EOF

sudo chmod 644 /etc/zsh/zprofile

cat >> ~/.zprofile << EOF
################################################################################################
##                                              Go                                            ##
################################################################################################
export GOPATH=/source/go/env
export PATH=\$PATH:\$GOPATH/bin

EOF

```

## 其它

```

## 9.0 夜间风格壁纸

cp /usr/share/backgrounds/gnome/adwaita-night.jpg ~/图片/

## KDE 禁用 kaccessibleapp 自动启动

sudo mv /usr/share/dbus-1/services/org.kde.kaccessible.service /usr/share/dbus-1/services/org.kde.kaccessible.service.backup

```
