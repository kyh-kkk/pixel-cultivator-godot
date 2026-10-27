# Pixel Cultivator（像素修仙录）

横版像素动作 RPG，基于 **Godot 4.3**，GDScript 2.0。修仙题材：练气->筑基->金丹->元婴->化神。

## 立即开始

1. 用 Godot 4.3+ 打开本项目
2. 按 F5 运行（主场景 scenes/main/main_menu.tscn）
3. 新游戏 -> 进入青风原

## 操作

| 按键 | 动作 |
|---|---|
| A/D 或 左右 | 移动 |
| Space | 跳跃/二段跳 |
| Shift | 冲刺（耗体力） |
| 鼠标左键/J | 普攻 |
| K/L/U | 技能 1/2/3 |
| R | 使用丹药 |
| E | 交互 |
| I | 背包 |
| Q | 任务日志 |
| T | 技能树 |
| Esc | 暂停 |

## 功能清单

### 战斗
- 近战普攻（伤害判定盒）
- 5 个技能：挥剑/剑气/火球术/旋身斩/万剑归宗
- 冷却+法力消耗+等级门槛
- 暴击（身法加成）、五行相克
- 受击无敌帧、击退、硬直

### 角色成长
- 六维属性：气血/攻击/身法/真元/防御/幸运
- 升级获得 3 点属性点
- 每 5 级突破大境界
- 经验曲线 100 * 1.18^(level-1)

### 敌人 AI
- 状态机：Idle->Patrol->Chase->Attack->Stun->Dead
- 4 种敌人：野狼妖/弓箭手妖/妖王亲卫/血翼妖王
- 接触伤害+攻击伤害分开

### 物品与掉落
- 丹药、灵石、武器、护甲、饰品
- 概率掉落表，幸运值提升掉率

### 系统
- 任务链：初入仙途->暗箭难防->灵石收集->妖王试炼
- 8 个成就
- 存档/读档（ConfigFile）
- 淡入淡出场景切换
- 双通道音频管理器

## 代码结构

```
scripts/
  core/        EventBus/GameManager/SaveManager/SceneLoader/AudioManager
  data/        Resource 静态数据
  player/      PlayerStats/PlayerController/PlayerCombat
  enemies/     EnemyBase 状态机
  systems/     CombatCalculator/LootDropper/QuestManager/AchievementManager
  ui/          HUD/背包/技能树/任务日志/暂停/设置
```

## 架构约定

- 跨节点通信走 EventBus，禁止硬引用
- 数据与逻辑分离
- 玩家三件套：Stats/Controller/Combat 互不耦合
- 新敌人：继承 EnemyBase + EnemyData.preset() 加配置
- 新物品/技能/任务/成就：改对应 DB 字典
