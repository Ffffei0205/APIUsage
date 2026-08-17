/**
 * 项目名称: ApiUsage
 * 文件名称: ProcessUtil
 * 创建时间: 2026-08-15 21:12
 * 创建人：  @author Ffffei
 * 文件描述: 进程工具，用于整个应用的启停等
 */
import { common, StartOptions, Want } from "@kit.AbilityKit";
import { Logger } from ".";
import { process } from '@kit.ArkTS';

const TAG = '[ProcessUtil]';


export class ProcessUtil {
  private static operationNotSupportedCode: number = 16000061;
  static startOptionCheckFailedCode: number = 16000067;

  /**
   * 退出应用
   */
  public static exitApp(): void {
    try {
      const pro = new process.ProcessManager();
      pro.exit(0);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `terminateSelf failed error:${err.code}, ${err.message}.`);
    }
  }

  /**
   * 终结ability
   * @param context
   */
  public static terminateAbility(context: common.UIAbilityContext): void {
    try {
      if (!context) {
        Logger.error(TAG, `terminateAbility failed, cause context is null or undefined.`);
        return;
      }
      context.terminateSelf().then(() => {
        Logger.info(TAG, 'terminateSelf succeed');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `terminateSelf failed. Cause ${err.code}, ${err.message}.`);
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `terminateSelf failed error:${err.code}, ${err.message}.`);
    }
  }


  /**
   * 把应用移到后台
   * @param context
   */
  public static moveAbilityToBackground(context: common.UIAbilityContext): void {
    try {
      if (!context) {
        Logger.error(TAG, `moveAbilityToBackground failed, cause context is null or undefined.`);
        return;
      }
      context.moveAbilityToBackground().then(() => {
        Logger.info(TAG, 'moveAbilityToBackground succeed');
      }).catch((err: BusinessError) => {
        if (err.code === ProcessUtil.operationNotSupportedCode) {
          ProcessUtil.hideAbility(context);
        }
        Logger.error(TAG, `moveAbilityToBackground failed, cause ${err.code}, ${err.message}`);
      })
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(TAG, `moveAbilityToBackground failed error: ${err.code}, ${err.message}`)
    }

  }

  /**
   * 打开应用
   * @param context
   * @param want
   * @param options
   * @returns
   */
  public static startAbility(context: common.UIAbilityContext, want: Want, options?: StartOptions): Promise<boolean> {
    try {
      if (!context) {
        Logger.error(TAG, `startAbility failed, cause context is null or undefined.`);
        return Promise.resolve(false);
      }
      return context.startAbility(want, options).then(() => {
        Logger.info(TAG, 'startAbility succeed');
        return true;
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `startAbility failed, cause ${err.code}, ${err.message}`);
        return false;
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `startAbility failed error: ${err.code}, ${err.message}`);
      return Promise.resolve(false);
    }
  }

  /**
   * 隐藏应用
   * @param context
   */
  private static hideAbility(context: common.UIAbilityContext): void {
    try {
      if (!context) {
        Logger.error(TAG, `hideAbility failed, cause context is null or undefined.`);
        return;
      }
      context.hideAbility().then(() => {
        Logger.info(TAG, 'hideAbility succeed');
      }).catch((err: BusinessError) => {
        if (err.code === ProcessUtil.startOptionCheckFailedCode) {
          ProcessUtil.terminateAbility(context);
        }
        Logger.error(TAG, `hideAbility failed, cause ${err.code}, ${err.message}`);
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `hideAbility failed error: ${err.code}, ${err.message}`);
      return;
    }
  }
}