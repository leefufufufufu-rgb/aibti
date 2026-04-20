# CMDE · 祈使句机枪手 - 5 Cases

## 人格画像
- **代码**: CMDE (Concrete + Minimal + Directive + Execute)
- **Slogan**: "精准定位，精准开火"
- **核心特征**: 短句 + 具体坐标 + 祈使动词，无寒暄、无解释、无讨论

---

### Case 1: 日常工作
**场景**: 给实体类补 getter，最常见的 CRUD 琐事。
**Prompt**:
```
User.java:42 加 email getter
```
**四维判定**:
- A/C: **C** — 指明文件和行号，坐标精准到行
- M/V: **M** — 7 个字符串，无一多余
- D/L: **D** — 祈使句"加"，无讨论口吻
- X/E: **E** — 直接动手，不问要不要、要不要顺便
- **最终代码**: CMDE

**为什么典型**:
- vs AMDE 甩锅侠："加个 getter" —— 哪个类？哪个字段？CMDE 给了坐标。
- vs CVDE 甲方爸爸："麻烦在 User.java 42 行给 email 字段加个 getter，记得遵循 JavaBean 规范，返回值是 String，如果 null 就返回空字符串好吗" —— CVDE 啰嗦，CMDE 7 字搞定。
- vs CMDX Bug 侦探："User.java:42 为什么没有 email getter？" —— CMDX 问，CMDE 令。

---

### Case 2: 压力/紧迫 (Bug 修复狙击)
**场景**: 线上 NPE，已经定位到代码，需要立即开火。
**Prompt**:
```
OrderService.pay():88 空指针，加 Optional
```
**四维判定**:
- A/C: **C** — 方法名 + 行号 + 症状 + 修复手段
- M/V: **M** — 没有"救命""急""快点"等情绪词，只有坐标和动作
- D/L: **D** — "加"，命令语气
- X/E: **E** — 故障下不发散讨论，直接给方案让执行
- **最终代码**: CMDE

**为什么典型**:
- 压力场景下，CMDE 不会像 AMDE 那样喊"线上挂了！快看看！"而是直接把弹药坐标甩出来。
- vs CMDX："OrderService.pay():88 为啥会空？" CMDE 不问为什么，直接开药方。
- 这就是"狙击式"：一句话命中目标并扣扳机。

---

### Case 3: 开放讨论/创意 (少见但锋利)
**场景**: 架构讨论，其他人都在发散，CMDE 扔一个具体点子就闭嘴。
**Prompt**:
```
Cache 层换 Caffeine，替掉 Guava
```
**四维判定**:
- A/C: **C** — 点名具体库（Caffeine / Guava），不泛谈"优化缓存"
- M/V: **M** — 一句话提案，不写三页 RFC
- D/L: **D** — "换"、"替掉"是祈使，不是"我觉得是否可以考虑"
- X/E: **E** — 直接推方案，不开"大家怎么看"圆桌
- **最终代码**: CMDE

**为什么典型**:
- CMDE 在创意场景很罕见，但一出手就是"库名 + 祈使动词"，像扔手雷。
- vs CVDE："我们能不能讨论一下缓存层的技术选型，比如 Caffeine 相比 Guava 的 W-TinyLFU 算法在命中率上..." —— CVDE 展开，CMDE 扔一句就走。
- vs AMDE："优化一下缓存" —— 无坐标，空话。

---

### Case 4: 失败/卡壳 (定位具体点继续命令)
**场景**: 上一轮改完编译不过，CMDE 不反思不吐槽，定位到报错那一行继续开火。
**Prompt**:
```
PayDTO.java:23 amount 改 BigDecimal，去掉 double
```
**四维判定**:
- A/C: **C** — 文件 + 行号 + 字段名 + 新旧类型对比
- M/V: **M** — 不写"上次改错了不好意思"，直接打补丁
- D/L: **D** — "改"、"去掉"双祈使
- X/E: **E** — 卡壳不改变行为模式，继续推进
- **最终代码**: CMDE

**为什么典型**:
- 失败场景下，AMDE 甩锅侠会说"还是不对啊"（无坐标），CMDE 会说"23 行 amount 改 BigDecimal"（定位 + 动作）。
- vs CMDX："PayDTO.java:23 为什么 amount 用 double？" —— CMDX 追问，CMDE 直接覆盖。
- 失败对 CMDE 来说只是换一个坐标继续射击。

---

### Case 5: 复杂多轮对话 (精准接续)
**场景**: 第 5 轮对话，前文已生成 AuthFilter，现在要挂上去，CMDE 只给差量指令。
**Prompt**:
```
SecurityConfig:56 chain 里 addFilterBefore AuthFilter
```
**四维判定**:
- A/C: **C** — 类名 + 行号 + API 方法（addFilterBefore）+ 参数（AuthFilter）
- M/V: **M** — 不重述前文"刚才我们生成的那个 AuthFilter..."，默认上下文已知
- D/L: **D** — 祈使动词"addFilterBefore"直接当指令
- X/E: **E** — 多轮中不回顾不总结，贴着上一条继续推进
- **最终代码**: CMDE

**为什么典型**:
- 多轮对话里，CVDE 会写"基于我们之前讨论的 AuthFilter，现在需要在 SecurityConfig 的 filterChain 方法中..."，CMDE 一行 API 调用直接拍死。
- vs AMDE："把那个过滤器挂上" —— 哪个过滤器？挂哪？CMDE 全给了。
- CMDE 在长对话中依然保持 < 50 字、含坐标、祈使句，是最稳定的接续模式。

---

## 识别口诀
> **看到"文件名:行号 + 动词" = CMDE**
> 没有"请"、没有"吗"、没有"为什么"，只有坐标和命令。
