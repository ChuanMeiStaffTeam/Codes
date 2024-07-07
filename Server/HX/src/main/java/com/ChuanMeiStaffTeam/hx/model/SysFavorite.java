package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.sql.Timestamp;

/**
 * 收藏表实体类
 */
@Data
@TableName("sys_favorites")
public class SysFavorite {
    @TableId(value = "favorite_id", type = IdType.AUTO)
    private Integer favoriteId;

    private Integer userId;

    private Integer postId;

    private Timestamp createdAt;
}
