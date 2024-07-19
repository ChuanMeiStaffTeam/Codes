package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import java.sql.Timestamp;
import java.util.List;
import com.baomidou.mybatisplus.annotation.TableLogic;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 帖子实体类，存储用户发布的帖子信息
 */
@Data
@TableName("sys_posts")
@NoArgsConstructor
@AllArgsConstructor
public class SysPost {


    /**
     * 帖子ID，自增主键
     */
    @TableId(value = "post_id", type = IdType.AUTO)
    private Integer postId;

    /**
     * 用户ID，发布此帖子的用户
     */
    @TableField("user_id")
    private Integer userId;

    /**
     * 图片说明 帖子标题
     */
    @TableField("caption")
    private String caption;

    /**
     * 位置
     */
    @TableField("location")
    private String location;

    /**
     * 创建时间
     */
    @TableField("created_at")
    private Timestamp createdAt;

    /**
     * 更新时间
     */
    @TableField("updated_at")
    private Timestamp updatedAt;

    /**
     * 点赞数
     */
    @TableField("likes_count")
    private Integer likesCount;

    /**
     * 评论数
     */
    @TableField("comments_count")
    private int commentsCount;

    /**
     * 收藏数
     */
    @TableField("favorite_count")
    private Integer favoriteCount;
    /**
     * 是否公开
     */
    @TableField("is_public")
    private boolean isPublic;

    /**
     * 标签列表，以JSON格式存储
     */
    @TableField("tags")
    private String tags;

    /**
     * 是否被删除 0表示未删除,1表示删除
     */
    @TableLogic
    @TableField("is_deleted")
    private boolean isDeleted;

    /**
     * 帖子可见性
     */
    @TableField("visibility")
    private String visibility;


    // 帖子图片url 该字段不存入数据库，而是通过图片表关联查询获取

    @TableField(exist = false)   // 不在数据库中创建该字段
    private List<String> imagesUrl;




}
