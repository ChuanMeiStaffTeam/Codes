package com.example.hx.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/28/10:17
 * @Description:
 */


@Configuration
public class ThreadPool {


    @Bean
    public ThreadPoolTaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);     // 核心线程数
        executor.setMaxPoolSize(10);     // 最大线程数
        executor.setQueueCapacity(20);   // 队列容量
        executor.setThreadNamePrefix("hx-");
        executor.initialize();         // 初始化线程池
        return executor;
    }
}
