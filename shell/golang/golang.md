# Go语言库

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
	- [go mod -replace](go_mod_replace)

## 游戏引擎

### G3N

```
sudo apt-get install xorg-dev libgl1-mesa-dev libopenal1 libopenal-dev libvorbis0a libvorbis-dev libvorbisfile3
go get -u github.com/g3n/engine/...
```

## 科学计算

### Gonum

```
go get -u gonum.org/v1/gonum/...
go get -u gonum.org/v1/plot/...
```

## 数据库驱动

### MySQL 

```
go get -u github.com/go-sql-driver/mysql
```

### PostgreSQL

```
go get -u github.com/lib/pq
```

### SQLite 

```
go get -u github.com/mattn/go-sqlite3
```

## 缓存

### Redis

```
go get -u github.com/gomodule/redigo/redis
```

## 命令行参数

### Cobra

```
go get -u github.com/spf13/cobra/cobra
```

## 图像处理

### bild

```
go get -u github.com/anthonynsimon/bild/...
```

### GIFT

```
go get -u github.com/disintegration/gift
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
go get -u github.com/revel/cmd/revel
```

### Gin

```
go get -u github.com/gin-gonic/gin
```

## 其它

### TOML

```
go get -u github.com/BurntSushi/toml
go get -u github.com/BurntSushi/toml/cmd/tomlv
tomlv some-toml-file.toml
```

### ln

> The 3D Line Art Engine

```
go get -u github.com/fogleman/ln/ln
```

### go_mod_replace

```
go mod edit -replace=golang.org/x/build=github.com/golang/build latest
go mod edit -replace=golang.org/x/crypto=github.com/golang/crypto latest
go mod edit -replace=golang.org/x/exp=github.com/golang/exp latest
go mod edit -replace=golang.org/x/image=github.com/golang/image latest
go mod edit -replace=golang.org/x/lint=github.com/golang/lint latest
go mod edit -replace=golang.org/x/mobile=github.com/golang/mobile latest
go mod edit -replace=golang.org/x/net=github.com/golang/net latest
go mod edit -replace=golang.org/x/oauth2=github.com/golang/oauth2 latest
go mod edit -replace=golang.org/x/perf=github.com/golang/perf latest
go mod edit -replace=golang.org/x/review=github.com/golang/review latest
go mod edit -replace=golang.org/x/sync=github.com/golang/sync latest
go mod edit -replace=golang.org/x/sys=github.com/golang/sys latest
go mod edit -replace=golang.org/x/text=github.com/golang/text latest
go mod edit -replace=golang.org/x/tools=github.com/golang/tools latest
go mod edit -replace=golang.org/x/time=github.com/golang/time latest

go mod edit -replace=google.golang.org/api=github.com/googleapis/google-api-go-client latest
go mod edit -replace=google.golang.org/appengine=github.com/golang/appengine latest
go mod edit -replace=google.golang.org/genproto=github.com/google/go-genproto latest
go mod edit -replace=google.golang.org/grpc=github.com/grpc/grpc-go latest

go mod edit -replace=cloud.google.com/go=github.com/googleapis/google-cloud-go latest
```

----

GFW,FUCK YOU!
