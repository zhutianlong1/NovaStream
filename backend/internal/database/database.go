package database

import (
	"fmt"

	"github.com/zhutianlong1/NovaStream/backend/config"
	"github.com/zhutianlong1/NovaStream/backend/internal/logs"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func Init() {
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
		logs.Logger.Fatalf("数据库连接失败: %v", err)
	}
	DB = db
	logs.Logger.Info("✅ 数据库连接成功")
}
