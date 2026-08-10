import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger  from "./Logger";

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
      const err: BusinessError = error
      Logger.error(TAG, 'createSession failed, code: ' + err.code.toString() + ', message: ' + err.message.toString());
    }
  }

  async fetchRes<T>(url: rcp.URLOrString, method?: rcp.HttpMethod, headers?: rcp.RequestHeaders,
    content?: rcp.RequestContent): Promise<HttpResponse<T>> {
    if (this.rcpSession) {
      try {
        const request = new rcp.Request(url)
        if (method) {
          request.method = method
        }
        if (headers) {
          request.headers = headers
        }
        const response = await this.rcpSession.fetch(request)
        const result: T = JSON.parse(JSON.stringify(response))
        if (response.statusCode == 200) {
          return {
            code: 200,
            data: result,
            message: 'success'
          }
        } else {
          Logger.error(TAG, 'request failed, statusCode: ' + response.statusCode.toString())
          const msg: string = response.toString() ?? ''
          return {
            code: response.statusCode,
            data: result,
            message: msg
          }
        }
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG,
          '获取数据出错,错误码:' + err.code.toString() + ';错误信息:' + err.message.toString())
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
