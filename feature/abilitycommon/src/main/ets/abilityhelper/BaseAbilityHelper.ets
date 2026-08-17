/**
 * 项目名称: ApiUsage
 * 文件名称: BaseAbilityHelper
 * 创建时间: 2026-08-14 20:04
 * 创建人：  @author Ffffei
 * 文件描述: ability中所有函数抽调，统一在这里进行
 */
import { common, Want, AbilityConstant, ConfigurationConstant } from "@kit.AbilityKit";
import { Logger, PageContext, StorageKey, WindowUtil } from "common";
import { window } from "@kit.ArkUI";


const TAG = '[BaseAbilityHelper]';

export class BaseAbilityHelper {
  private context?: common.UIAbilityContext;

  constructor() {
  }

  public doOnCreate(context: common.UIAbilityContext, want: Want, launchParam: AbilityConstant.LaunchParam):void {
    this.context = context
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error(TAG, `setColorMode failed, code: ${err.code}, message: ${err.message}`);
    }
    Logger.info(TAG, 'Ability onCreate');
  }

  public doOnDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  public doOnWindowStageCreate(windowStage: window.WindowStage):void {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    // 路由栈，一个模块一个
    AppStorage.setOrCreate(StorageKey.HOME_PAGE_CONTEXT, new PageContext());
    AppStorage.setOrCreate(StorageKey.BALANCE_PAGE_CONTEXT, new PageContext());
    AppStorage.setOrCreate(StorageKey.MINE_PAGE_CONTEXT, new PageContext());

    windowStage.loadContent('pages/SplashPage', (err) => {
      WindowUtil.initialize(windowStage);

      // 下面是错误处理
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${err.code} ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }
  public doOnWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    // TrackManager.getInstance().offTrackManager();
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  public doOnForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
  }

  public doOnBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }


}
