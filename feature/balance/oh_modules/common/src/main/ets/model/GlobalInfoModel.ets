/**
 * 项目名称: ApiUsage
 * 文件名称: GlobalInfoModel
 * 创建时间: 2026-08-10 23:00
 * 创建人：  @author Ffffei
 * 文件描述: 全局信息模型：存放设备/窗口的实时信息
 */

/**
 * 全局信息模型：存放设备/窗口的实时信息
 * 官方新版还放了 aspectRatio、needDynamicHideBar、decorHeight 等字段，
 * 这里只保留沉浸式教学需要的最小集合
 */
@Observed   // @Observed：对象内部字段变化时能通知订阅方刷新 UI
export class GlobalInfoModel {
  /** 顶部状态栏高度（vp） */
  public statusBarHeight: number = 0;

  /** 底部手势导航条高度（vp） */
  public naviIndicatorHeight: number = 0;

  /** 窗口宽度（vp），布局计算用 */
  public deviceWidth: number = 0;

  /** 窗口高度（vp），布局计算用 */
  public deviceHeight: number = 0;

  /** 宽度断点（sm/md/lg/xl），响应式布局用 */
  public widthBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
}