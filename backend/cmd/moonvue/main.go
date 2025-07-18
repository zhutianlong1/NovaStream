package main

import (
	"fmt"
	"os"

	"github.com/zhutianlong1/NovaStream/backend/config"
	"github.com/zhutianlong1/NovaStream/backend/internal/database"
	"github.com/zhutianlong1/NovaStream/backend/internal/logs"
	"github.com/zhutianlong1/NovaStream/backend/internal/router"
)

func main() {

	// 1. 加载配置
	if err := config.LoadConfig("config/config.yaml"); err != nil {
		panic(fmt.Sprintf("配置加载失败: %v", err))
	}

	// 2. 初始化日志
	logPath := config.Global.Log.File
	logLevel := config.Global.Log.Level
	logs.Init(logPath, logLevel)
	logs.Logger.Info("✅ 日志系统初始化完成")

	// 3. 判断是否生成模型
	if len(os.Args) > 1 && os.Args[1] == "gen" {
		logs.Logger.Info("🔧 进入模型生成模式")
		runGen()
		return
	}

	// 4. 初始化数据库
	database.Init()

	// 5. 启动 Gin 路由服务
	r := router.SetupRouter()

	port := config.Global.Server.Port
	addr := fmt.Sprintf(":%d", port)
	logs.Logger.Infof("🚀 启动服务 http://localhost%s", addr)
	if err := r.Run(addr); err != nil {
		logs.Logger.Fatalf("❌ 服务启动失败: %v", err)
	}
}
