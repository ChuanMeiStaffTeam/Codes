package com.ChuanMeiStaffTeam.hx.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/29/18:58
 * @Description:
 */

@Component
public class RedisUtil {


    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    // 设置指定的key-value 过期时间   设置
    public void set(String key, Object value, long timeout) {
        redisTemplate.opsForValue().set(key, value, timeout, TimeUnit.SECONDS); // 设置过期时间 单位秒
    }

    public String getString(String key) {
        return (String) redisTemplate.opsForValue().get(key);
    }

    public Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }
    // 根据key删除redis中的值
    public void delete(String key) {
        redisTemplate.delete(key);
    }


    // 获取key的过期时间
    public long getExpire(String key) {
        return redisTemplate.getExpire(key, TimeUnit.SECONDS);
    }
}
