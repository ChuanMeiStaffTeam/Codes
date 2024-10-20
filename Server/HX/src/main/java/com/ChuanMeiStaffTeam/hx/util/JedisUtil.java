package com.ChuanMeiStaffTeam.hx.util;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.resps.Tuple;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/07/17:06
 * @Description:
 */
public class JedisUtil {
    public static void main(String[] args) {
        JedisPool pool = new JedisPool("tcp://127.0.0.1:6379");
        try(Jedis jedis = pool.getResource()) {  // 获取连接 从redis连接池中取出一个连接
            // redis中的各种命令,就对应到了jedis中的各种方法
            String pong = jedis.ping();  // 测试redis是否连接成功  返回PONG  表示连接成功
            System.out.println(pong);
//            testGeneric(jedis);  // 测试redis的各种命令
//            testString(jedis);  // 测试redis的字符串命令
//            testString1(jedis);  // 测试redis的字符串命令
//            testString2(jedis);  // 测试redis的字符串命令
//            testString3(jedis);  // 测试redis的字符串命令


//            testList1(jedis);
//            testList2(jedis);
//            testList3(jedis);
//            testList4(jedis);



//            testSet1(jedis);
//            testSet2(jedis);
//            testSet3(jedis);
//            testSet4(jedis);
//            testSet5(jedis);



//            testHash1(jedis);
//            testHash2(jedis);
//            testHash3(jedis);
//            testHash4(jedis);



//            testZset1(jedis);
//            testZset2(jedis);
//            testZset3(jedis);
//            testZset4(jedis);
            testZset5(jedis);

        }
    }

    private static void testGeneric(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        jedis.set("key1","value1");
        jedis.set("key2","value2");
        jedis.set("key3","value3");
        System.out.println(jedis.get("key1"));
        System.out.println(jedis.get("key2"));
        System.out.println(jedis.get("key3"));
        System.out.println(jedis.keys("*"));  // 查看所有的key 返回值为set类型 不能保证顺序 唯一性

        System.out.println(jedis.del("key1"));
        System.out.println(jedis.exists("key1"));  // 判断该key1是否存在 存在返回true
        System.out.println(jedis.get("key1"));  // 输出null
        System.out.println(jedis.del("key2","key3"));  // 删除多个key
        System.out.println(jedis.keys("*"));  // 输出空

        jedis.set("key1", "value");
        System.out.println(jedis.type("key1")); // string类型

        jedis.lpush("key2", "a", "b", "c");  // 列表
        System.out.println(jedis.type("key2"));
        jedis.hset("key3", "name", "zhangsan");  // 哈希
        System.out.println(jedis.type("key3"));
        jedis.sadd("key4", "111", "222", "333");  // 集合
        System.out.println(jedis.type("key4"));
        jedis.zadd("key5", 1, "aaa");  // 有序集合
        System.out.println(jedis.type("key5"));
    }


    private static void testString(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        System.out.println("mset 和 mget");
        //字符串相关操作
        jedis.mset("key1","111","key2","222","key3","333"); //批量设置多个key-value
        List<String> list = jedis.mget("key1","key2","key3"); //批量获取多个key-value
        list.forEach(System.out::println);
    }

    private static void testString1(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        System.out.println("getrange 和 setrange");
        jedis.set("key","helloworld");
        String result = jedis.getrange("key",2,5);  //获取子串 前后均为闭区间
        System.out.println(result);
        jedis.setrange("key",2,"java");  //替换子串
        System.out.println(jedis.get("key"));
    }

    private static void testString2(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        System.out.println("append");
        jedis.set("key","hello");
        jedis.append("key","world");  //追加字符串
        System.out.println(jedis.get("key"));
    }

    private static void testString3(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        System.out.println("incr 和 decr");
        jedis.set("num","10");
        jedis.incr("num");  //自增
        System.out.println(jedis.get("num"));
        jedis.decr("num");  //自减
        System.out.println(jedis.get("num"));
    }


    /**
     * lpush 和 lrange
     * rpush 和 rpop lpop
     * blpop 和 brpop
     * llen
     * @param jedis
     */
    // list 操作
    private static void testList1(Jedis jedis) {
        System.out.println("lpush 和 lrange");
        jedis.flushAll();  // 清空redis所有数据
        // 向列表左侧添加元素
        long length = jedis.lpush("list1", "111", "222", "333");
        List<String> result = jedis.lrange("list1", 0, -1);  // 输出列表所有元素
        System.out.println(result);

    }

    private static void testList2(Jedis jedis) {
        System.out.println("rpush 和 lpop rpop");
        jedis.flushAll();
        // 向列表右侧添加元素
        long length = jedis.rpush("list2", "111", "222", "333");
        List<String> result = jedis.lrange("list2", 0, -1);
        System.out.println(result);
        String value = jedis.lpop("list2");  // 弹出列表左侧元素
        String value1 = jedis.rpop("list2");  // 弹出列表右侧元素
        System.out.println(value);
        System.out.println(value1);
        result = jedis.lrange("list2", 0, -1);
        System.out.println(result);
    }

    private static void testList3(Jedis jedis) {
        jedis.flushAll();
        // blpop 如果当前列表中有元素,行为和lpop一样,如果列表为空,则阻塞等待直到有元素加入列表
        // brpop 和 blpop 类似,但是是从右侧弹出元素
        System.out.println("blpop 和 brpop");
        // 返回值是一个list,第一个元素是key,第二个元素是value
        List<String> result = jedis.blpop(50, "key");  // 阻塞等待10秒,直到有元素加入列表
        System.out.println(result.get(0));
        System.out.println(result.get(1));
    }

    private static void testList4(Jedis jedis) {
        jedis.flushAll();
        System.out.println("llen");
        jedis.rpush("list1", "111", "222", "333");
        long length = jedis.llen("list1");  // 列表长度
        System.out.println(length);
    }


    /**
     *  sadd 添加元素 smembers   获取所有元素
     *  sismember  判断元素是否存在
     *  scard     获取集合元素个数
     *  spop      弹出元素 随机弹出
     *  sinter    交集
     *  sinnterstore  交集并存储 交集结果存储到另一个集合
     */
    // set 操作
    private static void testSet1(Jedis jedis) {
        System.out.println("sadd 和 smenbers");
        jedis.flushAll();
        jedis.sadd("set1", "111", "222", "333");
        Set<String> result = jedis.smembers("set1");
        System.out.println(result);
    }

    private static void testSet2(Jedis jedis) {
        System.out.println("sismember");
        jedis.flushAll();
        jedis.sadd("set1", "111", "222", "333");
        boolean result = jedis.sismember("set1", "222");
        System.out.println(result);
    }

    private static void testSet3(Jedis jedis) {
        System.out.println("scard");  // 获取集合元素个数
        jedis.flushAll();
        jedis.sadd("set1", "111", "222", "333");
        long result = jedis.scard("set1");
        System.out.println(result);
    }

    private static void testSet4(Jedis jedis) {
        System.out.println("spop");  // 弹出元素 随机弹出
        jedis.flushAll();
        jedis.sadd("set1", "111", "222", "333");
        String result = jedis.spop("set1");  // 随机弹出元素
        System.out.println(result);
        Set<String> set1 = jedis.smembers("set1");  // 输出剩余元素
        System.out.println(set1);
    }


    private static void testSet5(Jedis jedis) {
        System.out.println("sinter 和 sinnterstore");  // 交集
        jedis.flushAll();
        jedis.sadd("set1", "111", "222", "333");
        jedis.sadd("set2", "222", "333", "444");
        Set<String> result = jedis.sinter("set1", "set2");  // 交集
        System.out.println(result);
        jedis.sinterstore("set3", "set1", "set2");  // 交集并存储 交集结果存储到另一个集合
        Set<String> set3 = jedis.smembers("set3");  // 输出交集结果
        System.out.println(set3);
    }


    /**
     * hset 和 hget  获取和设置hash表中的元素
     * hexists 判断元素是否存在
     * hdel 删除元素
     * hkeys 和 hvals 获取所有key和value
     * hmget 和 hmset 批量获取和设置元素
     */
    // hash 操作
    private static void testHash1(Jedis jedis) {
        jedis.flushAll();  // 清空redis所有数据
        System.out.println("hset 和 hget");
        jedis.hset("hash1", "name", "zhangsan");
        String result = jedis.hget("hash1", "name");
        System.out.println(result);

        System.out.println("hmset 和 hmget");
        Map<String,String> fields = new HashMap<>();
        fields.put("age", "20");
        fields.put("sex", "male");
        jedis.hmset("hash2", fields);  // 批量设置元素
        List<String> hmget = jedis.hmget("hash2", "age", "sex");
        System.out.println(hmget);

    }

    private static void testHash2(Jedis jedis) {
        System.out.println("hexists");  // 判断元素是否存在
        jedis.flushAll();
        jedis.hset("hash1", "name", "zhangsan");
        jedis.hset("hash2", "age", "20");
        boolean result = jedis.hexists("hash1", "name");
        System.out.println(result);
        result = jedis.hexists("hash2", "name");
        System.out.println(result);
    }


    private static void testHash3(Jedis jedis) {
        System.out.println("hdel");  // 删除元素
        jedis.flushAll();
        jedis.hset("hash1", "name", "zhangsan");
        jedis.hset("hash1", "age", "20");
        long hdel = jedis.hdel("hash1", "age", "name");  // 删除元素
        System.out.println(hdel);
        System.out.println(jedis.hexists("hash1", "age"));
        System.out.println(jedis.hget("hash1", "age"));  // 输出null
    }

    private static void testHash4(Jedis jedis) {
        System.out.println("hkeys 和 hvals");  // 获取所有key和value
        jedis.flushAll();
        jedis.hset("hash1", "name", "zhangsan");
        jedis.hset("hash1", "age", "20");
        Set<String> hkeys = jedis.hkeys("hash1");  // 获取所有key
        System.out.println(hkeys);
        List<String> hvals = jedis.hvals("hash1");  // 获取所有value
        System.out.println(hvals);
    }


    /**
     * zadd 和 zrange  添加元素和获取元素
     * zcard 获取元素个数
     * zrem 删除元素
     * zscore 获取元素分数
     * zrank 获取元素排名
     */
    //zset 操作

    private static void testZset1(Jedis jedis) {
        System.out.println("zset 和 zrange");
        jedis.flushAll();
        jedis.zadd("zadd1", 10, "name1");
        Map<String,Double> map = new HashMap<>();
        map.put("name2",20.0);
        map.put("name3",30.0);
        long zadd1 = jedis.zadd("zadd1", map);
        System.out.println(zadd1);
        List<String> result = jedis.zrange("zadd1", 0, -1);
        System.out.println(result);
        // Tuple 是一个类,包含元素和分数
        List<Tuple> result1 = jedis.zrangeWithScores("zadd1", 0, -1);// 获取元素和分数
        System.out.println(result1);
        String element = result1.get(0).getElement();// 获取元素
        double score = result1.get(0).getScore();// 获取分数
        System.out.println(element);
        System.out.println(score);

    }

    private static void testZset2(Jedis jedis) {
        System.out.println("zcard");  // 获取元素个数
        jedis.flushAll();
        jedis.zadd("zadd1", 10, "name1");
        jedis.zadd("zadd1", 60, "name2");
        jedis.zadd("zadd1", 50, "name4");
        jedis.zadd("zadd1", 30, "name3");
        long zcard = jedis.zcard("zadd1");
        System.out.println(zcard);
    }

    private static void testZset3(Jedis jedis) {
        System.out.println("zrem");  // 删除元素
        jedis.flushAll();
        jedis.zadd("zadd1", 10, "name1");
        jedis.zadd("zadd1", 60, "name2");
        jedis.zadd("zadd1", 50, "name4");
        jedis.zadd("zadd1", 30, "name3");
        long zrem = jedis.zrem("zadd1", "name2", "name4");  // 删除元素
        System.out.println(zrem);
        List<String> result = jedis.zrange("zadd1", 0, -1);
        System.out.println(result);
    }

    private static void testZset4(Jedis jedis) {
        System.out.println("zscore");  // 获取元素分数
        jedis.flushAll();
        jedis.zadd("zadd1", 10, "name1");
        jedis.zadd("zadd1", 60, "name2");
        jedis.zadd("zadd1", 50, "name4");
        jedis.zadd("zadd1", 30, "name3");
        Double zscore = jedis.zscore("zadd1", "name2");// 获取元素分数
        System.out.println(zscore);
    }

    private static void testZset5(Jedis jedis) {
        System.out.println("zrank");  // 获取元素排名
        jedis.flushAll();
        jedis.zadd("zadd1", 10, "name1");
        jedis.zadd("zadd1", 60, "name2");
        jedis.zadd("zadd1", 50, "name4");
        jedis.zadd("zadd1", 30, "name3");
        Long zrank = jedis.zrank("zadd1", "name2");// 获取元素排名
        System.out.println(zrank);
    }
}
