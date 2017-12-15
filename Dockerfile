FROM alpine:latest as build
MAINTAINER Jessica Frazelle <jess@linux.com>

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN	apk add --no-cache \
	ca-certificates

RUN apk add --no-cache \
		go \
		git \
		gcc \
		libc-dev \
		libgcc
RUN go get github.com/golang/dep/cmd/dep

COPY Gopkg.lock Gopkg.toml /go/src/github.com/jessfraz/ghb0t/
WORKDIR /go/src/github.com/jessfraz/ghb0t/
RUN dep ensure -vendor-only


COPY . /go/src/github.com/jessfraz/ghb0t
RUN dep ensure
RUN go build -o /usr/bin/ghb0t .

FROM alpine:latest
COPY --from=build /usr/bin/ghb0t /usr/bin/ghb0t
ENTRYPOINT [ "ghb0t" ]
