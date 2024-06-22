package com.ChuanMeiStaffTeam.hx.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/20/23:09
 * @Description:
 */
@Configuration
public class WebSocketConfig {

    // 注入一个Bean对象
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();  // 注册一个ServerEndpointExporter，
        // 用于扫描带有@ServerEndpoint注解的类
    }
}
