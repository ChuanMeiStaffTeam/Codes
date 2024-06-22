package com.ChuanMeiStaffTeam.hx.config;

import org.springframework.cache.annotation.CachingConfigurerSupport;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig extends CachingConfigurerSupport {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();

        // 配置redis连接工厂
        template.setConnectionFactory(factory);
        //key序列化方式
        template.setKeySerializer(new StringRedisSerializer());  // key序列化 使用StringRedisSerializer序列化
        // 使得redis中的key为字符串类型
        //value序列化
        // 以json格式序列化对象
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer()); // value序列化 使用jackson序列化 序列化对象为json

        return template;
    }
}