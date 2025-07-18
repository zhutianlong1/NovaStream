package main

import (
	"fmt"

	"github.com/zhutianlong1/NovaStream/backend/config"
	"gorm.io/driver/mysql"
	"gorm.io/gen"
	"gorm.io/gorm"
)

func runGen() {
	dbConf := config.Global.Database

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=%s&parseTime=%v&loc=%s",
		dbConf.User,
		dbConf.Password,
		dbConf.Host,
		dbConf.Port,
		dbConf.Name,
		dbConf.Charset,
		dbConf.ParseTime,
		dbConf.Loc,
	)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(fmt.Sprintf("connect db failed: %v", err))
	}

	// 初始化 Generator，修正生成路径为 backend/internal/dao/query 和 backend/internal/dao/model
	g := gen.NewGenerator(gen.Config{
		OutPath:      "internal/dao/query",
		ModelPkgPath: "model",
		Mode:         gen.WithDefaultQuery | gen.WithQueryInterface,
	})

	g.UseDB(db)

	// 指定库表生成
	// tables := []string{
	// 	"users",
	// 	"articles",
	// }
	// for _, table := range tables {
	// 	g.GenerateModel(table)
	// }

	// 生成所有表
	models := g.GenerateAllTable()
	g.ApplyBasic(models...)

	g.Execute()

	fmt.Println("✅ GORM 模型生成成功")
}
