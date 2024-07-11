package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:43
 * @Description:
 */
@Data
@TableName("sys_comments")
public class SysComment {

    @TableId(value = "comment_id",type = IdType.AUTO)
    private Integer commentId;

    @TableField("post_id")
    private Integer postId;

    @TableField("user_id")
    private Integer userId;

    @TableField("comment_text")
    private String commentText;

    @TableField("created_at")
    private Timestamp createdAt;

    @TableField("updated_at")
    private Timestamp updatedAt;

    @TableField("parent_comment_id")
    private Integer parentCommentId;

    @TableField("is_active")
    @TableLogic  // 逻辑删除
    private Integer isActive;  // 0-未删除，1-已删除
}
