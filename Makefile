# MoonVue 项目 Makefile

# Go 后端相关命令
build:
	cd backend/cmd/moonvue && go build -o ../../bin/moonvue

run:
	cd backend && go run ./cmd/moonvue

test:
	cd backend && go test ./...

clean:
	rm -f backend/bin

# 数据库相关
migrate:
	@echo "请手动运行数据库迁移脚本: backend/db/schema.sql"

# 前端相关命令
install:
	cd frontend && pnpm install

dev:
	cd frontend && pnpm dev

build-fe:
	cd frontend && pnpm build

lint:
	cd frontend && pnpm lint

preview:
	cd frontend && pnpm preview

# 清理前端构建产物
clean-fe:
	rm -rf frontend/.output

.PHONY: build run test clean migrate install dev build-fe lint preview clean-fe
