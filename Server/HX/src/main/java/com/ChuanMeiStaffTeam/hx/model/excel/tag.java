package com.ChuanMeiStaffTeam.hx.model.excel;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/28/13:02
 * @Description:
 */
@Data
public class tag {
    @ExcelProperty("名称")
    private String name;
    @ExcelProperty("值") // 1 表示第二列
    private String value;
}
