package com.ChuanMeiStaffTeam.hx.model.vo;

import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/02/22:36
 * @Description:
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SysPostImage extends SysPost {
    private List<SysImage> images;

}
