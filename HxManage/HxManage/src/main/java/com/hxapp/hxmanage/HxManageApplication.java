package com.hxapp.hxmanage;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.hxapp.hxmanage.dao")
public class HxManageApplication {

    public static void main(String[] args) {
        SpringApplication.run(HxManageApplication.class, args);
    }
}
