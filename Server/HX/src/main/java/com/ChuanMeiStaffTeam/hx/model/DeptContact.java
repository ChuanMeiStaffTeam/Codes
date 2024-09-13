package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.io.Serializable;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Data
@TableName("sys_deptcontact")
public class DeptContact implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private String deptName;

    private String deptCode;

    private String userName;

    private String phoneNumber;

    private Timestamp createdAt;

    private Timestamp updatedAt;
}
