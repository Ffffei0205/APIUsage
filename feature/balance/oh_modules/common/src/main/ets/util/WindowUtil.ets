/**
 * 项目名称: ApiUsage
 * 文件名称: WindowUtil
 * 创建时间: 2026-08-10 00:00
 * 创建人：  @author Ffffei
 * 文件描述: 窗口工具类,所有跟窗口相关的系统能力都封装在这里
 */
import { window, UIContext } from '@kit.ArkUI';
import { Logger } from '.';
import { StorageKey } from '../constant/CommonEnums';
import { GlobalInfoModel } from '../model/GlobalInfoModel';


const TAG = '[WindowUtil]';

export class WindowUtil {
  /** 主窗口实例 */
  private static windowClass?: window.Window;
  /** UIContext：ArkUI 上下文，做单位换算用 */
  private static uiContext: UIContext;

  /**
   * 初始化入口：应用启动时调用一次
   */
  public static initialize(windowStage: window.WindowStage) {
    try {
      // 1. 拿到应用的主窗口
      WindowUtil.windowClass = windowStage.getMainWindowSync();

      // 2. 拿到 UIContext（px -> vp 换算要用）
      WindowUtil.uiContext = WindowUtil.windowClass.getUIContext();

      // 3. 存进 AppStorage，方便任何地方取用
      AppStorage.setOrCreate(StorageKey.UI_CONTEXT, WindowUtil.uiContext);

      // 4. 读取系统栏高度 + 注册监听
      WindowUtil.registerBreakpoint(WindowUtil.windowClass);

    } catch (error) {
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${error.code} ${error.message}`);
    }
  }


  private static registerBreakpoint(windowClass: window.Window) {
    try {
      // 先获取一个GlobalInfoModel对象，如果AppStorage有直接Get出来，如果没有先创建一个
      const globalInfoModel: GlobalInfoModel = AppStorage.Get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();

      // 顶部状态栏：TYPE_SYSTEM 的 topRect
      const systemAvoidArea: window.AvoidArea | undefined =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      globalInfoModel.statusBarHeight = WindowUtil.uiContext.px2vp(systemAvoidArea?.topRect?.height ?? 0)

      // 底部手势导航条：TYPE_NAVIGATION_INDICATOR 的 bottomRect
      const bottomArea: window.AvoidArea | undefined =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      globalInfoModel.naviIndicatorHeight = WindowUtil.uiContext.px2vp(bottomArea?.bottomRect?.height ?? 0)

      // 将globalInfoModel存入AppStorage，方便在任何地方使用
      AppStorage.setOrCreate(StorageKey.GLOBAL_INFO, globalInfoModel);

      /**
       * 窗口尺寸变化 → 更新宽高/断点
       * 这个不是沉浸式的代码
       */
      windowClass.on('windowSizeChange', (windowSize: window.Size) =>
      WindowUtil.setWindowSize(windowSize));

      // 系统栏区域变化（旋转、导航条显示/隐藏等）→ 更新高度
      windowClass.on('avoidAreaChange', (avoidAreaOption) => {
        if (avoidAreaOption.type === window.AvoidAreaType.TYPE_SYSTEM ||
          avoidAreaOption.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
        }
      });

    } catch (error) {
      Logger.error(TAG, `registerBreakpoint failed, Cause: ${error.code} ${error.message}`)
    }
  }

  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    const globalInfoModel: GlobalInfoModel =
      AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      globalInfoModel.statusBarHeight = WindowUtil.uiContext.px2vp(area?.topRect?.height ?? 0);
    } else {
      globalInfoModel.naviIndicatorHeight = WindowUtil.uiContext.px2vp(area?.bottomRect?.height ?? 0);
    }
    AppStorage.setOrCreate(StorageKey.GLOBAL_INFO, globalInfoModel);
  }


  public static setWindowSize(windowSize?: window.Size | window.Rect): void {
    // 先获取一个GlobalInfoModel对象，如果AppStorage有直接Get出来，如果没有先创建一个
    const globalInfoModel: GlobalInfoModel =
      AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
    // 如果存在windowSize 做更新
    if (windowSize) {
      globalInfoModel.deviceHeight = WindowUtil.uiContext.px2vp(windowSize.height);
      globalInfoModel.deviceWidth = WindowUtil.uiContext.px2vp(windowSize.width);
    }
    // 存入AppStorage
    globalInfoModel.widthBreakpoint = WindowUtil.uiContext.getWindowWidthBreakpoint();
    AppStorage.setOrCreate(StorageKey.GLOBAL_INFO, globalInfoModel);
  }
}