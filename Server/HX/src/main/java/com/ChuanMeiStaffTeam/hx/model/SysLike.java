package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.sql.Timestamp;

@Data
@TableName("sys_likes")
public class SysLike {

    @TableId(value = "like_id", type = IdType.AUTO)
    private Integer likeId;       // 点赞id 自增主键

    @TableField("post_id")
    private Integer postId;       // 帖子id

    @TableField("user_id")
    private Integer userId;       // 用户id

    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private Timestamp createdAt;  // 创建时间

    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private Timestamp updatedAt;  // 更改时间

    @TableField("is_active")
    @TableLogic  // 逻辑删除
    private int isActive;     // 是否有效 0-有效 1-无效
}
