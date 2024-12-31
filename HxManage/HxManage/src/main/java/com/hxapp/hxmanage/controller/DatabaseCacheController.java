//package com.hxapp.hxmanage.controller;
//
//import com.hxapp.hxmanage.model.MySqlStatus;
//import com.hxapp.hxmanage.model.RedisStatus;
//import com.hxapp.hxmanage.service.DatabaseCacheService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//
//@RestController()
//@RequestMapping("/api/database")
//public class DatabaseCacheController {
//
//    @Autowired
//    private DatabaseCacheService databaseCacheService;
//
//    // 获取 MySQL 状态信息
//    @GetMapping("/mysql/status")
//    public MySqlStatus getMySqlStatus() {
//        return databaseCacheService.getMySqlStatus();
//    }
//
//    // 获取 Redis 状态信息
//    @GetMapping("/redis/status")
//    public RedisStatus getRedisStatus() {
//        return databaseCacheService.getRedisStatus();
//    }
//}
