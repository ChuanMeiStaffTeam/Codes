package com.example.hx.util;

import jakarta.annotation.Resource;
import org.springframework.data.redis.core.RedisTemplate;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/11/20:21
 * @Description:
 */
public class RedisUtil {

    @Resource
    private RedisTemplate redisTemplate;


    // 设置字符串
    public void setString(String key, String value) {
        redisTemplate.opsForValue().set(key, value);
    }

    // 获取字符串
    public String getString(String key) {
        return (String) redisTemplate.opsForValue().get(key);
    }

}
