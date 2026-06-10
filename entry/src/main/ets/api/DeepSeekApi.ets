/**
 * 项目名称: ApiUsage
 * 文件名称: deepseekApi
 * 创建时间: 2026-06-11 00:38
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

// product/api/DeepSeekApi.ets
import {HttpUtil} from 'common'
import { rcp } from '@kit.RemoteCommunicationKit';

// 余额信息类型定义
export interface BalanceInfo {
  currency: string;
  total_balance: string;
  granted_balance: string;
  topped_up_balance: string;
}

export interface BalanceResponse {
  is_available: boolean;
  balance_infos: BalanceInfo[];
}

class DeepSeekApi {
  private httpUtil:HttpUtil = HttpUtil.getInstance()
  private static readonly BASE_URL = 'https://api.deepseek.com';

  // 查询账户余额
  async getBalance(apiKey: string): Promise<BalanceResponse> {
    const url = `${DeepSeekApi.BASE_URL}/user/balance`;
    const headers = {
      'Accept': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    } as rcp.RequestHeaders;
    const balance = await this.httpUtil.fetchRes<BalanceResponse>(url,'GET',headers)
    return balance.data;
  }
  // 后续可以继续添加其他 DeepSeek API 方法
}

export default new DeepSeekApi();