package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

@Data
@TableName("sys_follows")
public class SysFollows {

    @TableId(value = "follow_id", type = IdType.AUTO)
    private Integer followId;
    private Integer followerId;  // 关注者ID
    private Integer followingId;  // 被关注者ID
    private Timestamp createdAt;
    private Timestamp updatedAt;

    @TableLogic  // 逻辑删除
    private Boolean isDeleted;
}
