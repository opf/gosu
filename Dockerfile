FROM golang:1.23.8-bookworm

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		arch-test \
		file \
	; \
	rm -rf /var/lib/apt/lists/*

# disable CGO for ALL THE THINGS (to help ensure no libc)
ENV CGO_ENABLED=0

WORKDIR /go/src/github.com/tianon/gosu

COPY go.mod go.sum ./
RUN set -eux; \
	go mod download; \
	go mod verify

COPY *.go ./

# note: we cannot add "-s" here because then "govulncheck" does not work (see SECURITY.md); the ~0.2MiB increase (as of 2022-12-16, Go 1.18) is worth it
RUN go build -v -trimpath -ldflags '-d -w' -o /go/bin/gosu && /go/bin/gosu --version && /go/bin/gosu nobody id && /go/bin/gosu nobody ls -l /proc/self/fd