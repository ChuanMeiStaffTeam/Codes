package com.ChuanMeiStaffTeam.hx.model.vo;

import com.ChuanMeiStaffTeam.hx.model.SysPost;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/19/11:13
 * @Description:
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class paramPost extends SysPost {
    private List<String>  imageListUrl;
}
