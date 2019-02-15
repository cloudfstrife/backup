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
go get gonum.org/v1/plot/...
```

## 数据库驱动

### MySQL 

```
go get -u github.com/go-sql-driver/mysql
```

### PostgreSQL

```
go get github.com/lib/pq
```

### SQLite 

```
go get github.com/mattn/go-sqlite3
```

## 缓存

### Redis

```
go get github.com/gomodule/redigo/redis
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
go get github.com/BurntSushi/toml
go get github.com/BurntSushi/toml/cmd/tomlv
tomlv some-toml-file.toml
```
### ln

> The 3D Line Art Engine

```
go get github.com/fogleman/ln/ln
```
