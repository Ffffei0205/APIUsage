/**
 * 项目名称: ApiUsage
 * 文件名称: ApiSettingPageState
 * 创建时间: 2026-08-16
 * 创建人：  @author Ffffei
 * 文件描述: API Key 配置页面的数据容器，负责配置页的展示状态
 */
import { BaseState } from "common";

@Observed
export class ApiSettingPageState extends BaseState {
  public hasApiKey: boolean = false;       // 是否已配置 Key
  public savedKeyMasked: string = '';      // 已保存 Key 的脱敏显示
}
