/**
 * 项目名称: ApiUsage
 * 文件名称: BalancePageState
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述: 余额页面的数据容器，负责余额页的展示状态
 */
import { BaseHomeState } from "commonbusiness";
import { BalanceResponse } from "../api/DeepSeekApi";

@Observed
export class BalancePageState extends BaseHomeState {
  public hasApiKey: boolean = false;
  public savedKeyMasked: string = '';
  public balanceResponse?: BalanceResponse = undefined;
}
