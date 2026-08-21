# ApiUsage

一个在 原生HarmonyOS 上的 DeepSeek 用量辅助应用。

## 目前功能

- API Key 配置与本地保存。
- 通过 DeepSeek 开放平台提供的接口查询账户余额。

## 模块结构

```text
.
├─ entry/                    # 应用入口、EntryAbility、启动页和主页面
├─ common/                   # 公共模型、路由、存储、网络和通用 UI
├─ feature/abilitycommon/    # Ability 生命周期与首页基础能力
├─ feature/commonbusiness/   # 跨业务的首页 ViewModel、State 和组件
├─ feature/mine/             # 我的页面、设置、API 配置
└─ feature/balance/          # 余额页面、余额 
```

## 如何使用

1. 使用 DevEco Studio 打开项目根目录。
2. 确认已安装 HarmonyOS SDK、Node.js，并连接 HarmonyOS 手机或启动模拟器。
3. 在项目配置中配置签名，自动签名即可。
4. 运行 entry 。DevEco Studio会自动打包传至手机（目前仅做了手机适配，最低和目标API24）
