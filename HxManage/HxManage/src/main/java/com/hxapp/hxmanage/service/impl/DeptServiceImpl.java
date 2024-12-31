package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.DeptMapper;
import com.hxapp.hxmanage.model.DeptContact;
import com.hxapp.hxmanage.service.IdeptService;
import org.springframework.beans.factory.annotation.Autowired;
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
public class DeptServiceImpl extends ServiceImpl <DeptMapper, DeptContact> implements IdeptService {

    @Autowired
    private DeptMapper deptMapper;

    @Override
    public List<DeptContact> getAllDeptContact(Page<DeptContact> page) {
        return deptMapper.selectPage(page, null).getRecords();
    }

    @Override
    public Long getDeptCount() {
        return deptMapper.selectCount(new QueryWrapper<>());
    }
}
