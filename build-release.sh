#!/bin/bash
BUILD_DIR=$(dirname "$0")/build
mkdir -p $BUILD_DIR
cd $BUILD_DIR

VERSION=`date -u +%Y%m%d`
LDFLAGS="-X main.VERSION=$VERSION -s -w"
GCFLAGS=""
BINNAME="archey"
REPO="github.com/alexdreptu/archey-go"

go get $REPO

# AMD64 
OSES=(linux darwin windows freebsd)
for os in ${OSES[@]}; do
	suffix=""
	if [ "$os" == "windows" ]
	then
		suffix=".exe"
	fi
	env CGO_ENABLED=0 GOOS=$os GOARCH=amd64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_${os}_amd64${suffix} $REPO
	tar -zcf ${BINNAME}-${os}-amd64-$VERSION.tar.gz ${BINNAME}_${os}_amd64${suffix}
done

# 386
OSES=(linux windows)
for os in ${OSES[@]}; do
	suffix=""
	if [ "$os" == "windows" ]
	then
		suffix=".exe"
	fi
	env CGO_ENABLED=0 GOOS=$os GOARCH=386 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_${os}_386${suffix} $REPO
	tar -zcf ${BINNAME}-${os}-386-$VERSION.tar.gz ${BINNAME}_${os}_386${suffix}
done

# ARM
ARMS=(5 6 7)
for v in ${ARMS[@]}; do
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=$v go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_linux_arm$v  $REPO
tar -zcf ${BINNAME}-linux-arm$v-$VERSION.tar.gz ${BINNAME}_linux_arm$v
done

# ARM64
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_linux_arm64  $REPO
tar -zcf ${BINNAME}-linux-arm64-$VERSION.tar.gz ${BINNAME}_linux_arm64

#MIPS32LE
env CGO_ENABLED=0 GOOS=linux GOARCH=mipsle GOMIPS=softfloat go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_linux_mipsle $REPO
env CGO_ENABLED=0 GOOS=linux GOARCH=mips GOMIPS=softfloat go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_linux_mips $REPO

tar -zcf ${BINNAME}-linux-mipsle-$VERSION.tar.gz ${BINNAME}_linux_mipsle
tar -zcf ${BINNAME}-linux-mips-$VERSION.tar.gz ${BINNAME}_linux_mips
