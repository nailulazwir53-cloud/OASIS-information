.PHONY: build run test lint format migrate

build:
	go build -o bin/auth-service ./cmd/server

run: build
	./bin/auth-service

dev:
	go run ./cmd/server/main.go

test:
	go test -v ./...

lint:
	golangci-lint run ./...

format:
	go fmt ./...

migrate:
	psql -f migrations/001_create_users.sql

clean:
	rm -rf bin/
