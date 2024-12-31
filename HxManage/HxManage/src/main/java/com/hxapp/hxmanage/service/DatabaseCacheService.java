//package com.hxapp.hxmanage.service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.stereotype.Service;
//import org.springframework.data.redis.core.StringRedisTemplate;
//
//import java.util.Map;
//
//@Service
//public class DatabaseCacheService {
//
//    @Autowired
//    private JdbcTemplate jdbcTemplate;
//
//    @Autowired
//    private StringRedisTemplate redisTemplate;
//
//    // 获取 MySQL 状态信息
//    public MySqlStatus getMySqlStatus() {
//        MySqlStatus status = new MySqlStatus();
//
//        // 获取数据库版本
//        String version = jdbcTemplate.queryForObject("SELECT VERSION()", String.class);
//        status.setVersion(version);
//
//
//        // 获取连接数，防止结果为空引发异常
//        String sql = "SHOW STATUS LIKE 'Threads_connected'";
//        Map<String, Object> result = jdbcTemplate.queryForMap(sql);
//        Integer connections = result != null && result.containsKey("Value") ? Integer.valueOf(result.get("Value").toString()) : 0;
//
//        // 获取查询速率
//        sql = "SHOW GLOBAL STATUS LIKE 'Questions'";
//        result = jdbcTemplate.queryForMap(sql);
//        Integer queries = result != null ? Integer.valueOf(result.get("Value").toString()) : 0;
//        Integer queryRate = queries;
//
//        // 获取数据库大小
//        sql = "SELECT table_schema, ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) " +
//                "AS 'database_size_mb' FROM information_schema.tables WHERE table_schema = 'your_database' GROUP BY table_schema";
//        String databaseSize = jdbcTemplate.queryForObject(sql, String.class);
//
//        // 设置获取到的状态信息
//        status.setConnections(connections);
//        status.setQueryRate(queryRate + " queries/sec");
//        status.setDatabaseSize(databaseSize);
//
//        return status;
//    }
//
//    // 获取 Redis 状态信息
//    public RedisStatus getRedisStatus() {
//        RedisStatus status = new RedisStatus();
//
//        // 使用 Redis 的 INFO 命令获取状态信息
//        String info = String.valueOf(redisTemplate.getConnectionFactory().getConnection().info());
//
//        // 解析 INFO 命令结果
//        for (String line : info.split("\n")) {
//            if (line.startsWith("connected_clients:")) {
//                status.setConnections(Integer.parseInt(line.split(":")[1].trim()));
//            }
//            if (line.startsWith("total_commands_processed:")) {
//                status.setCommandCount(Integer.parseInt(line.split(":")[1].trim()));
//            }
//            if (line.startsWith("used_memory_human:")) {
//                status.setMemoryUsage(line.split(":")[1].trim());
//            }
//            if (line.startsWith("redis_version:")) {
//                status.setVersion(line.split(":")[1].trim());
//            }
//        }
//
//        return status;
//    }
//}
