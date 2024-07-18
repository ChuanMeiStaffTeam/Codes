package com.ChuanMeiStaffTeam.hx;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.ChuanMeiStaffTeam.hx.dao")
public class HxApplication {

    public static void main(String[] args) {
        SpringApplication.run(HxApplication.class, args);
        System.out.println("(๑•̀ㅂ•́)و✧  欢喜后端系统启动成功   (๑•̀ㅂ•́)و✧  \n");
    }

}
