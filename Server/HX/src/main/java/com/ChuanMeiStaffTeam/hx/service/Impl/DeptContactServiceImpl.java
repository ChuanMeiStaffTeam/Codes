package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.DeptContactMapper;
import com.ChuanMeiStaffTeam.hx.model.DeptContact;
import com.ChuanMeiStaffTeam.hx.service.IDeptContactService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/13/18:45
 * @Description:
 */
@Service
public class DeptContactServiceImpl extends ServiceImpl<DeptContactMapper, DeptContact> implements IDeptContactService {

    @Resource
    private DeptContactMapper deptContactMapper;


    @Override
    public int insertDeptContact(DeptContact deptContact) {
        return deptContactMapper.insert(deptContact);
    }
}
