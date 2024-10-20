package com.ChuanMeiStaffTeam.hx.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/20/15:41
 * @Description:
 */
//@RestController
//@RequestMapping("/my")
public class MyController {
//    @Autowired
    private StringRedisTemplate stringRedisTemplate;



//    @GetMapping("/testString")
//    @ResponseBody
    public void testString() {
//        stringRedisTemplate.opsForValue() // 操作字符串类型对象
        stringRedisTemplate.opsForValue().set("test", "test");
        stringRedisTemplate.opsForValue().set("test2", "test2");
        System.out.println(stringRedisTemplate.opsForValue().get("test"));
        System.out.println(stringRedisTemplate.opsForValue().get("test2"));
    }

//    @GetMapping("/testList")
//    @ResponseBody
    public void testList() {
//        执行原生的redis命令  execute要求回调方法中,必须有返回的值,返回值可以为空
        // 这个回调返回的值,就会作为execute的返回值
        stringRedisTemplate.execute((RedisConnection connection) -> {
            connection.flushAll(); // 清空redis
            return null;
        });
        stringRedisTemplate.opsForList().leftPush("test","111");
        stringRedisTemplate.opsForList().leftPush("test","222");
        stringRedisTemplate.opsForList().leftPush("test","333");
        String test = stringRedisTemplate.opsForList().rightPop("test"); // 弹出最后一个元素
        System.out.println(test);
        test = stringRedisTemplate.opsForList().rightPop("test"); //  弹出最后一个元素
        System.out.println(test);
        test = stringRedisTemplate.opsForList().rightPop("test"); //  弹出最后一个元素
        System.out.println(test);

    }


//
//    @GetMapping("/testSet")
//    @ResponseBody
    public String testSet() {
        stringRedisTemplate.execute((RedisConnection connection) -> {
            connection.flushAll(); // 清空redis
            return null;
        });

        Long len = stringRedisTemplate.opsForSet().add("test", "111", "222", "333");
        System.out.println(len);
        Set<String> test = stringRedisTemplate.opsForSet().members("test");
        System.out.println(test);
        Boolean test1 = stringRedisTemplate.opsForSet().isMember("test", "222");
        System.out.println(test1);

        Long test2 = stringRedisTemplate.opsForSet().size("test");
        System.out.println(test2);

        Long test3 = stringRedisTemplate.opsForSet().remove("test", "222", "111");
        System.out.println(test3);

        test = stringRedisTemplate.opsForSet().members("test"); // 取出集合中的元素
        System.out.println(test);
        return "ok";
    }
//
//    @GetMapping("/testHash")
//    @ResponseBody
    public String testHash() {
        stringRedisTemplate.execute((RedisConnection connection) -> {
            connection.flushAll();
            return null;
        });
        stringRedisTemplate.opsForHash().put("test", "111", "111");
        stringRedisTemplate.opsForHash().put("test", "222", "222");
        String test = (String) stringRedisTemplate.opsForHash().get("test", "222");
        System.out.println(test);
        Boolean test1 = stringRedisTemplate.opsForHash().hasKey("test", "222"); // 判断是否存在key
        System.out.println(test1);
        Long test2 = stringRedisTemplate.opsForHash().delete("test", "222", "111");
        System.out.println(test2);

        Long test3 = stringRedisTemplate.opsForHash().size("test");
        System.out.println(test3);

        Map<String, String> map = new HashMap<>();
        map.put("333", "333");
        map.put("444", "444");
        stringRedisTemplate.opsForHash().putAll("test", map);
        test3 = stringRedisTemplate.opsForHash().size("test");
        System.out.println(test3);

        return "ok";
    }
//
//    @GetMapping("/testZset")
//    @ResponseBody
    public String testZset() {
        stringRedisTemplate.execute((RedisConnection connection) -> {
            connection.flushAll();
            return null;
        });
        stringRedisTemplate.opsForZSet().add("test", "333", 3);
        stringRedisTemplate.opsForZSet().add("test", "111", 1);
        stringRedisTemplate.opsForZSet().add("test", "222", 2);
        Set<String> test = stringRedisTemplate.opsForZSet().range("test", 0, -1); // 取出集合中的元素 按照分数排序

        System.out.println(test);
        return "ok";
    }

}
