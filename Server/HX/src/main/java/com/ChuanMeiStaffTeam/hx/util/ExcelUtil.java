package com.ChuanMeiStaffTeam.hx.util;

import com.ChuanMeiStaffTeam.hx.model.excel.ppass;
import com.ChuanMeiStaffTeam.hx.model.excel.tag;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.write.builder.ExcelWriterBuilder;
import com.alibaba.excel.write.builder.ExcelWriterSheetBuilder;
import com.alibaba.excel.write.metadata.WriteSheet;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/28/13:05
 * @Description:
 */
public class ExcelUtil {

    public static void main(String[] args) {
        List<ppass> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            ppass p = new ppass();
            p.setEmail("" + i + "@qq.com");
            p.setName("" + i);
            p.setPhone("1234567890");
            list.add(p);
        }

        List<tag> list1 = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            tag t = new tag();
            t.setName("name" + i);
            t.setValue("value" + i);
            list1.add(t);
        }
        ExcelWriter write = EasyExcel.write("C:\\Users\\d\\Desktop\\新建文件夹\\test.xlsx").build();
        WriteSheet writeSheet1 = EasyExcel.writerSheet("test").build();
        WriteSheet writeSheet2 = EasyExcel.writerSheet("tag").build();
        write.write(list, writeSheet1);
        write.write(list1, writeSheet2);
        write.finish();
    }
}
