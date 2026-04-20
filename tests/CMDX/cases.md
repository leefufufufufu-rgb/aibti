# CMDX · Bug 侦探 - 5 Cases

### Case 1: 日常工作 - 方法返回值诡异
**场景**: 同事改完代码后某个方法返回 null，日常排查。
**Prompt**:
```
OrderService.java:88 getAmount() 返回 null，为啥？明明上面 set 过了
```
**四维判定**:
- A/C: **C**（给出文件+行号+具体现象，全是事实坐标）
- M/V: **M**（一句话，没废话）
- D/L: **D**（虽是问句但带证据强势追，直接要原因）
- X/E: **X**（"为啥"典型的探究开头）
- **最终代码**: CMDX
**为什么典型**: CMDE 会说"去 debug OrderService.getAmount"直接命令；CMLX 会说"我代码报错了不知道咋办"没坐标；CVLX 会长篇铺垫"我在想这个方法设计是不是有问题…"。CMDX 只丢一个坐标 + 一个"为啥"。

### Case 2: 压力/紧迫 - 线上 OOM 但指标平静
**场景**: 生产告警，Pod 被 kill，但 Grafana 内存曲线没飙高，时间紧。
**Prompt**:
```
pod OOMKilled 但 container_memory 没涨，咋回事？RSS 也正常
```
**四维判定**:
- A/C: **C**（OOMKilled + container_memory + RSS 三个硬指标）
- M/V: **M**（极短，紧迫感）
- D/L: **D**（质问式，不是求安慰）
- X/E: **X**（"咋回事"就是要根因）
- **最终代码**: CMDX
**为什么典型**: CMDE 紧迫时会"立刻重启 pod，加内存 limit"先动手；CMLX 会"线上炸了救命"情绪化；CVLX 来不及长谈。CMDX 在火场也只问一句带证据的"为啥"。

### Case 3: 开放讨论/创意 - 反常行为探究
**场景**: 闲聊时发现 Redis QPS 周期性掉零，想搞清楚原因。
**Prompt**:
```
Redis QPS 每 5 分钟掉一次零，持续 3 秒，啥原因？没定时任务啊
```
**四维判定**:
- A/C: **C**（5 分钟 + 3 秒 + QPS 具体周期）
- M/V: **M**（短句陈述 + 短句追问）
- D/L: **D**（不是"大家觉得呢"，是"啥原因"要答案）
- X/E: **X**（开放探究一个现象）
- **最终代码**: CMDX
**为什么典型**: CMDE 开放场景下会说"给我三个排查方向"要清单；CVLX 会"我们来聊聊 Redis 的周期性抖动本质…"发散；CMLX 只会"Redis 怪怪的"没数据。CMDX 带数据但保持探究姿态。

### Case 4: 失败/卡壳 - 追到底不放手
**场景**: 改了半天 Nginx 502 还在，已排查一轮，继续追。
**Prompt**:
```
upstream timeout 改到 60s 还 502，日志 no live upstreams，为啥？后端 health 是绿的
```
**四维判定**:
- A/C: **C**（timeout 60s + 错误关键字 + health 状态全是证据）
- M/V: **M**（没诉苦，全是坐标）
- D/L: **D**（卡壳但不示弱，带证据追）
- X/E: **X**（"为啥"再次追因）
- **最终代码**: CMDX
**为什么典型**: CMLX 卡壳会"我搞不定了怎么办"；CMDE 会"再试试调 keepalive"命令式下一步；CVLX 会"我们是不是忽略了 health check 的语义…"反思。CMDX 卡壳时手里还攥着三份证据继续问"为啥"。

### Case 5: 复杂多轮对话 - 层层逼近真相
**场景**: 一个分布式事务数据不一致 bug，多轮追问收敛。
**Prompt**:
```
Turn1: TCC confirm 成功但 DB 没更新，User.java:42 log 打了「ok」，为啥？
Turn2: 那 @Transactional 传播是 REQUIRED，还是丢？
Turn3: binlog 里压根没这条 UPDATE，是被 rollback 了还是没进 SQL？
```
**四维判定**:
- A/C: **C**（每轮都丢新证据：行号/注解/binlog）
- M/V: **M**（每轮都短，不废话）
- D/L: **D**（三连追，步步紧逼）
- X/E: **X**（每轮都是探究疑点）
- **最终代码**: CMDX
**为什么典型**: CVLX 多轮会越聊越长越哲学；CMDE 多轮会"换个方案直接用 Seata"改道；CMLX 多轮会越问越懵。CMDX 多轮像刑侦：每一轮掏出新证据，锁死上一轮的假设，直到真相露头。
