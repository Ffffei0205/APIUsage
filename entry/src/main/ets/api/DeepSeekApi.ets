import {HttpUtil} from 'common'
import { rcp } from '@kit.RemoteCommunicationKit';

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

  async getBalance(apiKey: string): Promise<BalanceResponse> {
    const url = DeepSeekApi.BASE_URL + '/user/balance';
    const headers: rcp.RequestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + apiKey
    };
    const balance = await this.httpUtil.fetchRes<BalanceResponse>(url, 'GET', headers)
    return balance.data;
  }
}

export default new DeepSeekApi();
