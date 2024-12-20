package com.ChuanMeiStaffTeam.hx.interceptor;

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
                .excludePathPatterns("/api/sms/**")
                .excludePathPatterns("/swagger-ui.html/**", "/webjars/**", "/v2/**", "/swagger-resources/**")
                .excludePathPatterns("/api/user/**")  // 排除登录  注册接口
                .excludePathPatterns("/api/postImage/visitorGetPost")  // 排除游客获取帖子接口
                .excludePathPatterns("/api/postImage/defaultSearchPosts")  // 排除默认搜索帖子接口
                .excludePathPatterns("/api/postImage/searchPosts")  // 排除搜索帖子接口
                .excludePathPatterns("/api/userinfo/searchUser") // 排除根据id获取帖子接口
                .excludePathPatterns("/api/postImage/getPostByTag"); // 排除根据tag获取帖子接口
    }
}
