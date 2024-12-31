package com.hxapp.hxmanage.interceptor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.Resource;


@Configuration
public class AppInterceptorConfigurer implements WebMvcConfigurer {

    //注入登录自定义拦截器
    @Resource
    private LoginInterceptor loginInterceptor;
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 添加登录拦截器
        registry.addInterceptor(loginInterceptor) // 添加⽤⼾登录拦截器
                .addPathPatterns("/**") // 拦截所有请求
                // 排除swagger接口
                .excludePathPatterns("/jquery/**")
                .excludePathPatterns("/js/**")
                .excludePathPatterns("/css/**")
                .excludePathPatterns("/layui-v2.9.13/**")
                .excludePathPatterns("/echarts/**")
                .excludePathPatterns("/**.ico")
                .excludePathPatterns("/login.html")
                .excludePathPatterns("/api/sms/**")  // 排除短信接口
                .excludePathPatterns("/api/login/**"); // 排除登录
    }
}
