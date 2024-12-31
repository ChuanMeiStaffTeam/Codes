package com.hxapp.hxmanage.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.model.DeptContact;
import com.hxapp.hxmanage.service.IdeptService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/12/12/09:53
 * @Description:
 */
@RestController
@RequestMapping("/api/dept")
@Slf4j
public class DeptController {


    @Autowired
    private IdeptService deptService;


    @GetMapping("/list")
    public AppResult list(@RequestParam(defaultValue = "1") Integer page,
                          @RequestParam(defaultValue = "10") Integer limit){
        Page<DeptContact> deptPage = new Page<>(page,limit);
        List<DeptContact> list = deptService.getAllDeptContact(deptPage);
        log.info("获取企业列表信息成功");
        Map<String, Object> map = new HashMap<>();
        // 返回岗位列表
        map.put("total", deptPage.getTotal());  // 总条数
        map.put("records", list);
        return AppResult.success(map);
    }
}
