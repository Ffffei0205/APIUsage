/**
 * 项目名称: ApiUsage
 * 文件名称: HttpUtil
 * 创建时间: 2026-06-04 00:22
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */
import { rcp } from '@kit.RemoteCommunicationKit';
import Logger from '../utils/Logger';

const TAG = '[HttpUtil]'

export class HttpUtil {
  public static instance: HttpUtil;
  rcpSession?: rcp.Session;

  constructor() {
    this.rcpCreateSession()
  }


  public static getInstance(): HttpUtil {
    if (!HttpUtil.instance) {
      HttpUtil.instance = new HttpUtil()
    }
    return HttpUtil.instance
  }

  rcpCreateSession(): void {
    try {
      this.rcpSession = rcp.createSession();
    } catch (error) {
      Logger.error(TAG, `createSession failed, code: ${error.code}, message: ${error.message.toString()}`);
    }
  }

  async fetchRes<T>(url: rcp.URLOrString, method?: rcp.HttpMethod, headers?: rcp.RequestHeaders,
    content?: rcp.RequestContent): Promise<HttpResponse<T>> {
    if (this.rcpSession) {
      try {
        Logger.info(TAG,`${method},${headers}`)
        const request = new rcp.Request(url)
        if (method) {
          request.method = method
        }
        if (headers) {
          request.headers = headers
        }
        const response = await this.rcpSession.fetch(request)
        if (response.statusCode == 200) {
          const result = response.toJSON() as T
          return {
            code: 200,
            data: result,
            message: 'ddd'
          }
        } else {
          const result = response.toJSON() as T
          Logger.error(TAG,`${response.statusCode},${response.toString()}}`)
          return {
            code: response.statusCode,
            data: result,
            message: response.toString() as string
          }
        }
      } catch (error) {
        Logger.error(TAG,
          `获取数据出错,错误码:${(error as BusinessError).code};错误信息:${(error as BusinessError).message}`)
        throw new Error('网络请求失败')
      }
    } else {
      this.rcpCreateSession()
      return this.fetchRes<T>(url, method, headers, content)
    }
  }




}

export interface HttpResponse<T> {
  code: number;
  data: T;
  message: string
}