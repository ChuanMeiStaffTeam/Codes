package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import lombok.Data;

import java.sql.Timestamp;

/**
 * 图片实体类，存储帖子中的图片信息
 */
@Data
@TableName("sys_images")
public class SysImage {

    /**
     * 图片ID，自增主键
     */
    @TableId(value = "image_id", type = IdType.AUTO)
    private Integer imageId;

    /**
     * 帖子ID，外键，关联到sys_posts表
     */
    @TableField("post_id")
    private Integer postId;

    /**
     * 图片URL
     */
    @TableField("image_url")
    private String imageUrl;

    /**
     * 图片创建时间
     */
    @TableField("created_at")
    private Timestamp createdAt;

    /**
     * 图片更新时间
     */
    @TableField("updated_at")
    private Timestamp updatedAt;

    /**
     * 图片宽度
     */
    @TableField("image_width")
    private Integer imageWidth;

    /**
     * 图片高度
     */
    @TableField("image_height")
    private Integer imageHeight;

    /**
     * 使用的滤镜
     */
    @TableField("filter_used")
    private String filterUsed;

}
