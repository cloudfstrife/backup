# Go语言库

- [开发工具](#开发工具)
	- [goleak](#goleak)
- [游戏引擎](#游戏引擎)
	- [G3N](#G3N)
- [科学计算](#科学计算)
	- [Gonum](#Gonum)
- [数据库驱动](#数据库驱动)
	- [MySQL](#MySQL)
	- [PostgreSQL](#PostgreSQL)
	- [SQLite](#SQLite)
- [缓存](#缓存)
	- [Redis](#Redis)
- [命令行](#命令行)
	- [Cobra](#Cobra)
- [图像处理](#图像处理)
	- [bild](#bild)
	- [GIFT](#GIFT)
- [日志](#日志)
	- [logrus](#logrus)
- [网络](#网络)
	- [gopacket](#gopacket)
- [Web框架](#Web框架)
	- [Revel Framework](#Revel)
	- [Gin Web Framework](#Gin)
- [其它](#其它)
	- [TOML](#TOML)
	- [ln](#ln)
	- [go mod -replace](#go_mod_replace)

## 开发工具

### goleak

```
go get -u go.uber.org/goleak
```

## 游戏引擎

### G3N

```
# Debian
sudo apt-get install xorg-dev libgl1-mesa-dev libopenal1 libopenal-dev libvorbis0a libvorbis-dev libvorbisfile3

go get -u -v github.com/g3n/engine/...
```

## 科学计算

### Gonum

```
go get -u -v gonum.org/v1/gonum/...
go get -u -v gonum.org/v1/plot/...
```

## 数据库驱动

### MySQL 

```
go get -u -v github.com/go-sql-driver/mysql
```

### PostgreSQL

```
go get -u -v github.com/lib/pq
```

### SQLite 

```
go get -u -v github.com/mattn/go-sqlite3
```

## 缓存

### Redis

```
go get -u -v github.com/gomodule/redigo/redis
```

## 命令行参数

### Cobra

```
go get -u -v github.com/spf13/cobra/cobra
```

## 图像处理

### bild

```
go get -u -v github.com/anthonynsimon/bild/...
```

### GIFT

```
go get -u -v github.com/disintegration/gift
```

## 日志

### logrus

```
go get -u -v github.com/sirupsen/logrus
```

## 网络

### gopacket

```
go get -u -v github.com/google/gopacket
```

## Web框架

### Revel

```
go get -u -v github.com/revel/cmd/revel
```

### Gin

```
go get -u -v github.com/gin-gonic/gin
```

## 其它

### TOML

```
go get -u -v github.com/BurntSushi/toml
go get -u -v github.com/BurntSushi/toml/cmd/tomlv
tomlv some-toml-file.toml

go get -u -v github.com/komkom/toml
```

### Protocol Buffers

```
go get -u github.com/golang/protobuf/protoc-gen-go
```

### ln

> The 3D Line Art Engine

```
go get -u -v github.com/fogleman/ln/ln
```

### goproxy

```
go env -w GOPROXY=https://goproxy.io,direct
go env -w GOPROXY=https://goproxy.cn,direct
```

### reset go env

```
go env -u GO111MODULE
go env -u GOARCH
go env -u GOBIN
go env -u GOCACHE
go env -u GOFLAGS
go env -u GONOPROXY
go env -u GONOSUMDB
go env -u GOOS
go env -u GOPATH
go env -u GOPRIVATE
go env -u GOPROXY
go env -u GOROOT
go env -u GOSUMDB
go env -u GOTMPDIR
go env -u GCCGO
go env -u AR
go env -u CC
go env -u CXX
go env -u CGO_ENABLED
go env -u CGO_CFLAGS
go env -u CGO_CPPFLAGS
go env -u CGO_CXXFLAGS
go env -u CGO_FFLAGS
go env -u CGO_LDFLAGS
go env -u PKG_CONFIG
```

----

GFW,FUCK YOU!
