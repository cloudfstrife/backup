# debian

## 基本组件安装

### KDE

```
sudo apt-get clean
sudo apt-get update
sudo apt-get install curl wget apt-transport-https vim xclip tree rar zip unrar unzip p7zip net-tools \
git clang clang-format clang-tidy clang-tools make make-doc gdb gdb-doc cmake cmake-doc \
irssi irssi-plugin-otr irssi-plugin-xmpp irssi-scripts blender deluge deluge-torrent aria2 \
chromium chromium-l10n chromium-sandbox  chromium-ublock-origin \
fonts-wqy-microhei fonts-wqy-zenhei fonts-noto-cjk fonts-noto-cjk-extra \
sddm-theme-breeze sddm-theme-elarun sddm-theme-maldives sddm-theme-maui sddm-theme-maya \
sddm-theme-debian-breeze sddm-theme-debian-elarun sddm-theme-debian-maui 

```

### Gnome

```
sudo apt-get install gedit-source-code-browser-plugin rhythmbox-plugin-alternative-toolbar vim xclip tree \
gcc gcc-doc g++ make make-doc gdb gdb-doc clang clang-format clang-tidy \
irssi irssi-scripts irssi-plugin-xmpp irssi-plugin-otr \
breeze-cursor-theme breeze-icon-theme numix-gtk-theme \
rar zip unrar unzip p7zip net-tools \
codelite codelite-plugins blender deluge deluge-torrent aria2 git retext liferea
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

sudo chmod 777  /etc/vim/vimrc
sudo echo -e "\n\n\" 设定默认解码" >> /etc/vim/vimrc
sudo echo -e "set fenc=utf-8" >> /etc/vim/vimrc
sudo echo -e "set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不要使用vi的键盘模式，而是vim自己的 " >> /etc/vim/vimrc
sudo echo -e "set nocompatible" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 语法高亮" >> /etc/vim/vimrc
sudo echo -e "syntax on" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不要闪烁" >> /etc/vim/vimrc
sudo echo -e "set novisualbell" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不让vim发出讨厌的滴滴声" >> /etc/vim/vimrc
sudo echo -e "set noerrorbells" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 在状态行上显示光标所在位置的行号和列号" >> /etc/vim/vimrc
sudo echo -e "set ruler" >> /etc/vim/vimrc
sudo echo -e "set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 我的状态行显示的内容" >> /etc/vim/vimrc
sudo echo -e "set statusline=%F%m%r%h%w\[POS=%l,%v][%p%%]\%{strftime(\\\"%d/%m/%y\ -\ %H:%M\\\")}" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 总是显示状态行" >> /etc/vim/vimrc
sudo echo -e "set laststatus=2" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 命令行（在状态行下）的高度，默认为1，这里是2" >> /etc/vim/vimrc
sudo echo -e "set cmdheight=2" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不要备份文件" >> /etc/vim/vimrc
sudo echo -e "set nobackup" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 增强模式中的命令行自动完成操作" >> /etc/vim/vimrc
sudo echo -e "set wildmenu" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 侦测文件类型" >> /etc/vim/vimrc
sudo echo -e "filetype on" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 载入文件类型插件" >> /etc/vim/vimrc
sudo echo -e "filetype plugin on" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 为特定文件类型载入相关缩进文件" >> /etc/vim/vimrc
sudo echo -e "filetype indent on" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 搜索和匹配" >> /etc/vim/vimrc
sudo echo -e "\" 高亮显示匹配的括号" >> /etc/vim/vimrc
sudo echo -e "set showmatch" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 匹配括号高亮的时间（单位是十分之一秒）" >> /etc/vim/vimrc
sudo echo -e "set matchtime=5" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 在搜索的时候忽略大小写" >> /etc/vim/vimrc
sudo echo -e "set ignorecase" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不要高亮被搜索的句子（phrases）" >> /etc/vim/vimrc
sudo echo -e "set nohlsearch" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）" >> /etc/vim/vimrc
sudo echo -e "set incsearch" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 文本格式和排版" >> /etc/vim/vimrc
sudo echo -e "\" 自动格式化" >> /etc/vim/vimrc
sudo echo -e "set formatoptions=tcrqn" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 继承前一行的缩进方式，特别适用于多行注释" >> /etc/vim/vimrc
sudo echo -e "set autoindent" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 为C程序提供自动缩进" >> /etc/vim/vimrc
sudo echo -e "set smartindent" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 使用C样式的缩进" >> /etc/vim/vimrc
sudo echo -e "set cindent" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 制表符为4" >> /etc/vim/vimrc
sudo echo -e "set tabstop=4" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 统一缩进为4" >> /etc/vim/vimrc
sudo echo -e "set softtabstop=4" >> /etc/vim/vimrc
sudo echo -e "set shiftwidth=4" >> /etc/vim/vimrc
sudo echo -e "" >> /etc/vim/vimrc
sudo echo -e "\" 不要用空格代替制表符" >> /etc/vim/vimrc
sudo echo -e "set noexpandtab" >> /etc/vim/vimrc
sudo chmod 644 /etc/vim/vimrc
```

## golang

```
sudo cp /etc/profile /etc/profile.backup

sudo chmod 777 /etc/profile
sudo echo -e "\n\n\n################################################################################################" >> /etc/profile
sudo echo -e "##                                           golang" >> /etc/profile
sudo echo -e "################################################################################################" >> /etc/profile
sudo echo -e "export GOROOT=/usr/local/go" >> /etc/profile
sudo echo -e "export PATH=\$GOROOT/bin:\$PATH" >> /etc/profile
sudo echo -e "export GOPATH=/source/golang/env" >> /etc/profile
sudo chmod 644 /etc/profile
```

## 其它

```

## 9.0 夜间风格壁纸

cp /usr/share/backgrounds/gnome/adwaita-night.jpg ~/图片/

## KDE 禁用 kaccessibleapp 自动启动

sudo mv /usr/share/dbus-1/services/org.kde.kaccessible.service /usr/share/dbus-1/services/org.kde.kaccessible.service.backup

```