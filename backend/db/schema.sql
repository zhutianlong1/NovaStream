CREATE TABLE IF NOT EXISTS users (
  username VARCHAR(255) PRIMARY KEY,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS play_records (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  `key` VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  source_name VARCHAR(255) NOT NULL,
  cover VARCHAR(255) NOT NULL,
  year VARCHAR(255) NOT NULL,
  index_episode INT NOT NULL,
  total_episodes INT NOT NULL,
  play_time INT NOT NULL,
  total_time INT NOT NULL,
  save_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  search_title VARCHAR(255),
  UNIQUE(username, `key`),
  FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS favorites (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  `key` VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  source_name VARCHAR(255) NOT NULL,
  cover VARCHAR(255) NOT NULL,
  year VARCHAR(255) NOT NULL,
  total_episodes INT NOT NULL,
  save_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(username, `key`),
  FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS search_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  keyword VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(username, keyword),
  FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS admin_config (
  id INT PRIMARY KEY DEFAULT 1,
  config TEXT NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 基本索引
CREATE INDEX idx_play_records_username ON play_records(username);
CREATE INDEX idx_favorites_username ON favorites(username);
CREATE INDEX idx_search_history_username ON search_history(username);

-- 复合索引优化查询性能
-- 播放记录：用户名+键值的复合索引，用于快速查找特定记录
CREATE INDEX idx_play_records_username_key ON play_records(username, `key`);
-- 播放记录：用户名+保存时间的复合索引，用于按时间排序的查询
CREATE INDEX idx_play_records_username_save_time ON play_records(username, save_time DESC);

-- 收藏：用户名+键值的复合索引，用于快速查找特定收藏
CREATE INDEX idx_favorites_username_key ON favorites(username, `key`);
-- 收藏：用户名+保存时间的复合索引，用于按时间排序的查询
CREATE INDEX idx_favorites_username_save_time ON favorites(username, save_time DESC);

-- 搜索历史：用户名+关键词的复合索引，用于快速查找/删除特定搜索记录
CREATE INDEX idx_search_history_username_keyword ON search_history(username, keyword);
-- 搜索历史：用户名+创建时间的复合索引，用于按时间排序的查询
CREATE INDEX idx_search_history_username_created_at ON search_history(username, created_at DESC);

-- 搜索历史清理查询的优化索引
CREATE INDEX idx_search_history_username_id_created_at ON search_history(username, id, created_at DESC);