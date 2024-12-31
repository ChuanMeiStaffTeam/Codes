package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hxapp.hxmanage.model.DeptContact;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/12/12/09:54
 * @Description:
 */

@Service
public interface IdeptService extends IService<DeptContact> {


    List<DeptContact> getAllDeptContact(Page<DeptContact> page);

    Long getDeptCount();
}
