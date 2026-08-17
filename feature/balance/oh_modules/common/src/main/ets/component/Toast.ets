/**
 * 项目名称: ApiUsage
 * 文件名称: Toast
 * 创建时间: 2026-08-15 21:01
 * 创建人：  @author Ffffei
 * 文件描述: 弹窗提示
 */
import { PromptAction } from '@kit.ArkUI';
import { StorageKey } from '../constant';
import Logger from '../util/Logger';


const TAG: string = '[HMOS_Toast]';


class Toast {
  private longToastTime: number = 2000;

  public showToast(message: ResourceStr, duration?: number) {
    try {
      const uiContext: UIContext | undefined = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT);
      if (!uiContext) {
        Logger.error(TAG, `Show toast failed, cause uicontext is undefined`);
        return
      }
      const promptAction: PromptAction = uiContext.getPromptAction();
      promptAction.showToast({
        message: message,
        duration: duration,
      });
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(TAG, `Show toast error, the code is ${error.code}, the message is ${error.message}`);
    }
  }

  public showLongToast(message: ResourceStr) {
    this.showToast(message, this.longToastTime);
  }
}

export default new Toast();